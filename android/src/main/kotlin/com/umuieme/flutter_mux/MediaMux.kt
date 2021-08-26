package com.umuieme.flutter_mux

import android.media.MediaCodec
import android.media.MediaExtractor
import android.media.MediaMuxer
import android.util.Log
import java.io.File
import java.io.IOException
import java.nio.ByteBuffer


import android.media.MediaMetadataRetriever;
class MediaMux {

    fun muxAudioAndVideo(outputVideo: String, audioPath: String, videoPath: String): Boolean {
        var isAudioFinish=false
        try {
            Log.e("MediaMux", "video output == $videoPath")
            val file = File(outputVideo)
            file.createNewFile()
            val videoExtractor = MediaExtractor()
            videoExtractor.setDataSource(videoPath)
            val audioExtractor = MediaExtractor()
            audioExtractor.setDataSource(audioPath)
            val muxer = MediaMuxer(outputVideo, MediaMuxer.OutputFormat.MUXER_OUTPUT_MPEG_4)
            videoExtractor.selectTrack(0)
            val retrieverSrc = MediaMetadataRetriever()
            retrieverSrc.setDataSource(videoPath)

            //for audio
            val retrieverAudioSrc = MediaMetadataRetriever()
            retrieverAudioSrc.setDataSource(videoPath)

            val degreesString: String? =
                retrieverSrc.extractMetadata(MediaMetadataRetriever.METADATA_KEY_VIDEO_ROTATION)
            if (degreesString != null) {
                val degrees: Int = Integer.parseInt(degreesString)
                if (degrees >= 0) {
                    muxer.setOrientationHint(degrees)
                }
            }
            val time: String? =
                retrieverSrc.extractMetadata(MediaMetadataRetriever.METADATA_KEY_DURATION)
            val videotimeduration: Long? = time!!.toLong()

            //for Audio
            val audiotime: String? =
                retrieverAudioSrc.extractMetadata(MediaMetadataRetriever.METADATA_KEY_DURATION)
            val audiotimeduration: Long? = time!!.toLong()


            val videoFormat = videoExtractor.getTrackFormat(0)
            val videoTrack = muxer.addTrack(videoFormat)
            audioExtractor.selectTrack(0)
            val audioFormat = audioExtractor.getTrackFormat(0)
            val audioTrack = muxer.addTrack(audioFormat)
            var sawEOS = false
            var sawEOA=false
            val offset = 0
            val sampleSize = 256*1024
            val videoBuf = ByteBuffer.allocate(sampleSize)
            val audioBuf = ByteBuffer.allocate(sampleSize)
            val videoBufferInfo = MediaCodec.BufferInfo()
            val audioBufferInfo = MediaCodec.BufferInfo()
            videoExtractor.seekTo(0, MediaExtractor.SEEK_TO_CLOSEST_SYNC)
            audioExtractor.seekTo(0, MediaExtractor.SEEK_TO_CLOSEST_SYNC)
            muxer.start()
            var videoBufferSize = 0;

            while (!sawEOS) {
                videoBufferInfo.offset = offset
                videoBufferInfo.size = videoExtractor.readSampleData(videoBuf, offset)
                if (videoBufferInfo.size < 0) {
                    sawEOS = true
                    videoBufferInfo.size = 0

                } else {
                    videoBufferSize += videoBufferInfo.size
                    videoBufferInfo.presentationTimeUs = videoExtractor.sampleTime
                    videoBufferInfo.flags = videoExtractor.sampleFlags
                    muxer.writeSampleData(videoTrack, videoBuf, videoBufferInfo)
                    videoExtractor.advance()
                }
            }


            while (!sawEOA) {
                    audioBufferInfo.offset = offset
                    audioBufferInfo.size = audioExtractor.readSampleData(audioBuf, offset)
             if (audioBufferInfo.size < 0) {
                    sawEOA = true
                    audioBufferInfo.size = 0
                } else {


                 if (audioBufferInfo.presentationTimeUs > videotimeduration!!) {
                  //   audioExtractor.unselectTrack(audioTrackIndex);
                     break;
                 }

                        audioBufferInfo.presentationTimeUs = audioExtractor.sampleTime
                        audioBufferInfo.flags = audioExtractor.sampleFlags
                        muxer.writeSampleData(audioTrack, audioBuf, audioBufferInfo)
                        audioExtractor.advance()




                }
            }
            try {
                muxer.stop()
                muxer.release()
            } catch (ignore: IllegalStateException) {
            }
        } catch (e: IOException) {
            e.printStackTrace()
            return false
        }
        return true
    }
}