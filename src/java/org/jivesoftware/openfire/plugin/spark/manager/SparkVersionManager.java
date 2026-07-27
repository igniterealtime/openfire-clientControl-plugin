/*
 * Copyright (C) 1999-2008 Jive Software, 2024 Ignite Realtime Foundation. All rights reserved.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package org.jivesoftware.openfire.plugin.spark.manager;

import java.io.IOException;
import java.io.InputStream;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.attribute.FileTime;
import java.security.MessageDigest;
import java.util.HashMap;
import java.util.Locale;
import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import org.dom4j.Element;
import org.jivesoftware.openfire.XMPPServer;
import org.jivesoftware.util.JiveGlobals;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.xmpp.component.Component;
import org.xmpp.component.ComponentException;
import org.xmpp.component.ComponentManager;
import org.xmpp.component.ComponentManagerFactory;
import org.xmpp.packet.IQ;
import org.xmpp.packet.JID;
import org.xmpp.packet.Packet;
import org.xmpp.packet.PacketError;

/**
 * Provides support for server administrators to control the global updating of the Jive Spark IM client.
 * (<a href="https://igniterealtime.org/projects/spark/">Spark</a>).
 * <p>
 * The basic functionality is to query the server for the latest client
 * version and return that information. The version comparison is left to
 * the client itself, so as to keep the SparkVersionManager simple.
 *
 * @author Derek DeMoro
 */
public class SparkVersionManager implements Component {
    
    private static final Logger Log = LoggerFactory.getLogger(SparkVersionManager.class);
    private static final Map<Path, CachedChecksum> CHECKSUM_CACHE = new HashMap<>();
    
    private final ComponentManager componentManager;
    public static String SERVICE_NAME = "updater";

    /**
     * Empty constructor for initializing.
     */
    public SparkVersionManager() {
        // Initialize ComponentManager
        componentManager = ComponentManagerFactory.getComponentManager();
    }

    /**
     * Returns the name of this plugin.
     *
     * @return the name of this plugin.
     */
    @Override
    public String getName() {
        return "Spark Version Manager";
    }

    /**
     * Returns a brief description of this plugin.
     *
     * @return a brief description of this plugin.
     */
    @Override
    public String getDescription() {
        return "Allow admins to control the updating of the Spark IM Client.";
    }

    @Override
    public void processPacket(Packet packet) {
        if (packet instanceof IQ) {
            IQ iqPacket = (IQ)packet;

            if (IQ.Type.get == iqPacket.getType()) {
                Element childElement = (iqPacket).getChildElement();
                String namespace = null;
                if (childElement != null) {
                    namespace = childElement.getNamespaceURI();
                }

                // Handle any disco info requests.
                if ("http://jabber.org/protocol/disco#info".equals(namespace)) {
                    handleDiscoInfo(iqPacket);
                }

                // Handle any disco item requests.
                else if ("http://jabber.org/protocol/disco#items".equals(namespace)) {
                    handleDiscoItems(iqPacket);
                }
                // Handle a jabber spark request.
                else if ("jabber:iq:spark".equals(namespace)) {
                    handleSparkIQ(iqPacket);
                }
            }
            else if (IQ.Type.error == iqPacket.getType() || IQ.Type.result == iqPacket.getType()) {
                // Ignore these packets
            }
            else {
                // Return error since this is an unknown service request
                IQ reply = IQ.createResultIQ(iqPacket);
                reply.setError(PacketError.Condition.service_unavailable);
                sendPacket(reply);
            }
        }
    }

    private void handleSparkIQ(IQ packet) {
        IQ reply;
        Element iq = packet.getChildElement();

        // Define default values
        Element osElement = iq.element("os");
        String os = osElement != null ? osElement.getText() : null;
        Element archElement = iq.element("arch");
        String arch = archElement != null ? archElement.getTextTrim().toLowerCase(Locale.ROOT) : null;

        reply = IQ.createResultIQ(packet);

        // Handle Invalid Requests
        if (os == null || (!os.equals("windows") && !os.equals("mac") && !os.equals("linux"))) {
            reply.setChildElement(packet.getChildElement().createCopy());
            reply.setError(new PacketError(PacketError.Condition.not_acceptable, PacketError.Type.modify, "Invalid OS"));
            sendPacket(reply);
            return;
        }

        Element sparkElement = reply.setChildElement("query", "jabber:iq:spark");
        String client = resolveClientPackage(os, arch);

        if (client != null && !client.isBlank()) {
            Path buildDir = JiveGlobals.getHomePath().resolve("enterprise").resolve("spark").toAbsolutePath().normalize();
            Path clientFile = buildDir.resolve(client).normalize();
            if (!clientFile.startsWith(buildDir) || !Files.isRegularFile(clientFile)) {
                reply.setChildElement(packet.getChildElement().createCopy());
                reply.setError(new PacketError(PacketError.Condition.item_not_found, PacketError.Type.cancel, "Client package not found"));
                sendPacket(reply);
                return;
            }

            String fileName = clientFile.getFileName().toString();
            String versionNumber = extractVersion(fileName);
            if (versionNumber == null) {
                reply.setChildElement(packet.getChildElement().createCopy());
                reply.setError(new PacketError(PacketError.Condition.not_acceptable, PacketError.Type.modify, "Unable to determine package version from filename"));
                sendPacket(reply);
                return;
            }
            sparkElement.addElement("version").setText(versionNumber);

            try {
                FileTime updatedTime = Files.getLastModifiedTime(clientFile);
                sparkElement.addElement("updatedTime").setText(String.valueOf(updatedTime.toInstant().toEpochMilli()));
            } catch (IOException e) {
                Log.info("Unable to determine the last-modified time of file {}", clientFile, e);
            }
            sparkElement.addElement("fileName").setText(fileName);
            try {
                sparkElement.addElement("sha256").setText(sha256(clientFile));
            } catch (Exception e) {
                Log.warn("Unable to calculate SHA-256 for {}", clientFile, e);
            }

            // Add download url
            String downloadURL = JiveGlobals.getProperty("spark.client.downloadURL");
            String server = XMPPServer.getInstance().getServerInfo().getXMPPDomain();
            downloadURL = downloadURL.replace("127.0.0.1", server);

            sparkElement.addElement("downloadURL").setText(downloadURL + "?client=" + URLEncoder.encode(fileName, StandardCharsets.UTF_8));

            String displayMessage = JiveGlobals.getProperty("spark.client.displayMessage");
            if (displayMessage != null && !displayMessage.trim().isEmpty()) {
                sparkElement.addElement("displayMessage").setText(displayMessage);
            }
        }
        else {
            reply.setChildElement(packet.getChildElement().createCopy());
            reply.setError(new PacketError(PacketError.Condition.item_not_found, PacketError.Type.cancel, "OS client unsupported"));
            sendPacket(reply);
            return;
        }

        sendPacket(reply);
    }

    static String architecturePropertyName(String os, String arch) {
        if (os == null || arch == null) {
            return null;
        }
        String normalizedOs = os.toLowerCase(Locale.ROOT);
        String normalizedArch = arch.toLowerCase(Locale.ROOT);
        if (!normalizedOs.equals("windows") && !normalizedOs.equals("mac") && !normalizedOs.equals("linux")) {
            return null;
        }
        if (!normalizedArch.equals("x86") && !normalizedArch.equals("x64") && !normalizedArch.equals("arm64")) {
            return null;
        }
        return "spark." + normalizedOs + "." + normalizedArch + ".client";
    }

    private static String resolveClientPackage(String os, String arch) {
        String architectureProperty = architecturePropertyName(os, arch);
        if (architectureProperty != null) {
            String architectureClient = JiveGlobals.getProperty(architectureProperty);
            if (architectureClient != null && !architectureClient.isBlank()) {
                return architectureClient;
            }
        }
        return JiveGlobals.getProperty("spark." + os + ".client");
    }

    private static final Pattern VERSION_PATTERN = Pattern.compile(
        "(\\d+(?:[._]\\d+){1,3})(?:[-._]?((?:snapshot|alpha|beta|rc)\\d*))?",
        Pattern.CASE_INSENSITIVE
    );

    static String extractVersion(String client) {
        Matcher matcher = VERSION_PATTERN.matcher(client);
        if (!matcher.find()) {
            return null;
        }
        String version = matcher.group(1).replace('_', '.');
        String qualifier = matcher.group(2);
        if (qualifier == null) {
            return version;
        }
        return version + "-" + qualifier.toLowerCase(Locale.ROOT);
    }

    static synchronized String sha256(Path path) throws Exception {
        Path normalizedPath = path.toAbsolutePath().normalize();
        for (int attempt = 0; attempt < 3; attempt++) {
            long size = Files.size(normalizedPath);
            FileTime modified = Files.getLastModifiedTime(normalizedPath);
            CachedChecksum cached = CHECKSUM_CACHE.get(normalizedPath);
            if (cached != null && cached.matches(size, modified)) {
                return cached.sha256;
            }

            String sha256 = calculateSha256(normalizedPath);
            long finalSize = Files.size(normalizedPath);
            FileTime finalModified = Files.getLastModifiedTime(normalizedPath);
            if (size == finalSize && modified.equals(finalModified)) {
                CHECKSUM_CACHE.put(normalizedPath, new CachedChecksum(finalSize, finalModified, sha256));
                return sha256;
            }
        }
        throw new IOException("Spark client package changed while its SHA-256 was calculated: " + normalizedPath);
    }

    private static String calculateSha256(Path path) throws Exception {
        MessageDigest digest = MessageDigest.getInstance("SHA-256");
        try (InputStream in = Files.newInputStream(path)) {
            byte[] buffer = new byte[64 * 1024];
            int read;
            while ((read = in.read(buffer)) >= 0) {
                digest.update(buffer, 0, read);
            }
        }
        StringBuilder result = new StringBuilder(64);
        for (byte value : digest.digest()) {
            result.append(String.format("%02x", value));
        }
        return result.toString();
    }

    private static class CachedChecksum {
        private final long size;
        private final FileTime modified;
        private final String sha256;

        private CachedChecksum(long size, FileTime modified, String sha256) {
            this.size = size;
            this.modified = modified;
            this.sha256 = sha256;
        }

        private boolean matches(long size, FileTime modified) {
            return this.size == size && this.modified.equals(modified);
        }
    }

    private void handleDiscoItems(IQ packet) {
        IQ replyPacket = IQ.createResultIQ(packet);
        replyPacket.setChildElement("query", "http://jabber.org/protocol/disco#items");
        sendPacket(replyPacket);
    }

    private void handleDiscoInfo(IQ packet) {
        IQ replyPacket = IQ.createResultIQ(packet);
        Element responseElement =
                replyPacket.setChildElement("query", "http://jabber.org/protocol/disco#info");

        Element identity = responseElement.addElement("identity");
        identity.addAttribute("category", "updater");
        identity.addAttribute("type", "text");
        identity.addAttribute("name", "Spark Updater");
        
        responseElement.addElement("feature").addAttribute("var", "jabber:iq:updater");

        sendPacket(replyPacket);
    }

    @Override
    public void initialize(JID jid, ComponentManager componentManager) throws ComponentException {
        // Do nothing.
    }

    @Override
    public void start() {
        // Do nothing
    }

    @Override
    public void shutdown() {
        // Do nothing.
    }

    private void sendPacket(Packet packet) {
        try {
            componentManager.sendPacket(this, packet);
        }
        catch (ComponentException e) {
            Log.error(e.getMessage(), e);
        }
    }
}
