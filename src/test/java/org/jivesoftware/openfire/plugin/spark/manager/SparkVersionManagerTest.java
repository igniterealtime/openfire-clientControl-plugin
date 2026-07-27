package org.jivesoftware.openfire.plugin.spark.manager;

import org.junit.Test;

import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertNull;

public class SparkVersionManagerTest {

    @Test
    public void buildsArchitecturePropertiesForAllSupportedPlatforms() {
        assertEquals("spark.windows.x86.client", SparkVersionManager.architecturePropertyName("windows", "x86"));
        assertEquals("spark.windows.x64.client", SparkVersionManager.architecturePropertyName("windows", "x64"));
        assertEquals("spark.windows.arm64.client", SparkVersionManager.architecturePropertyName("windows", "arm64"));
        assertEquals("spark.mac.x64.client", SparkVersionManager.architecturePropertyName("mac", "x64"));
        assertEquals("spark.mac.arm64.client", SparkVersionManager.architecturePropertyName("mac", "arm64"));
        assertEquals("spark.linux.x86.client", SparkVersionManager.architecturePropertyName("linux", "x86"));
        assertEquals("spark.linux.x64.client", SparkVersionManager.architecturePropertyName("linux", "x64"));
        assertEquals("spark.linux.arm64.client", SparkVersionManager.architecturePropertyName("linux", "arm64"));
    }

    @Test
    public void rejectsUnsupportedArchitectureProperties() {
        assertNull(SparkVersionManager.architecturePropertyName("windows", "sparc"));
        assertNull(SparkVersionManager.architecturePropertyName("android", "arm64"));
        assertNull(SparkVersionManager.architecturePropertyName(null, "x64"));
        assertNull(SparkVersionManager.architecturePropertyName("linux", null));
    }

    @Test
    public void extractsReleaseVersion() {
        assertEquals("3.1.0", SparkVersionManager.extractVersion("spark_3_1_0-with-jre.exe"));
    }

    @Test
    public void extractsPrereleaseVersion() {
        assertEquals("3.1.1-rc2", SparkVersionManager.extractVersion("spark_3_1_1_rc2-with-jre.exe"));
    }

    @Test
    public void rejectsFilenameWithoutVersion() {
        assertNull(SparkVersionManager.extractVersion("spark-current.exe"));
    }

    @Test
    public void invalidatesCachedSha256WhenFileChanges() throws Exception {
        Path file = Files.createTempFile("spark-client-cache", ".exe");
        try {
            Files.write(file, "Spark".getBytes(StandardCharsets.UTF_8));
            assertEquals(
                "529bc3b07127ecb7e53a4dcf1991d9152c24537d919178022b2c42657f79a26b",
                SparkVersionManager.sha256(file)
            );

            Files.write(file, "Spark2".getBytes(StandardCharsets.UTF_8));
            assertEquals(
                "76b41059a0f13be29af4dc2343f59a0e07e866d385a14262c073bdeb0fbb3f5f",
                SparkVersionManager.sha256(file)
            );
        } finally {
            Files.deleteIfExists(file);
        }
    }

    @Test
    public void calculatesSha256() throws Exception {
        Path file = Files.createTempFile("spark-client", ".exe");
        try {
            Files.write(file, "Spark".getBytes(StandardCharsets.UTF_8));
            assertEquals(
                "529bc3b07127ecb7e53a4dcf1991d9152c24537d919178022b2c42657f79a26b",
                SparkVersionManager.sha256(file)
            );
        } finally {
            Files.deleteIfExists(file);
        }
    }
}
