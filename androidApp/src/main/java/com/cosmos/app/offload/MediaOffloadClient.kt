package com.cosmos.app.offload

import com.cosmos.app.data.MediaProcessingJob

class MediaOffloadClient {
    fun triggerFFmpegTranscode(fileId: String, format: String): MediaProcessingJob {
        return MediaProcessingJob(
            jobId = "job-ffmpeg-" + System.currentTimeMillis(),
            status = "PROCESSING",
            inputFormat = "RAW",
            outputFormat = format,
            progress = 10
        )
    }

    fun triggerBackgroundMatteRemoval(fileId: String): MediaProcessingJob {
        return MediaProcessingJob(
            jobId = "job-matte-" + System.currentTimeMillis(),
            status = "PROCESSING",
            inputFormat = "MP4",
            outputFormat = "WEBM_ALPHA",
            progress = 15
        )
    }

    fun compressAvatarMesh(modelId: String): MediaProcessingJob {
        return MediaProcessingJob(
            jobId = "job-mesh-" + System.currentTimeMillis(),
            status = "PROCESSING",
            inputFormat = "OBJ_150K",
            outputFormat = "GLTF_35K",
            progress = 25
        )
    }
}
