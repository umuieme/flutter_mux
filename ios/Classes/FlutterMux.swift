//
//  FlutterMux.swift
//  flutter_mux
//
//  Created by Umesh Basnet on 26/04/2021.
//

import Foundation
import AVFoundation

public class FlutterMux{
    
    public func mixAudioVideo(outputFile: String, videoFile: String, audioFile: String, result:  @escaping FlutterResult){
        
        let mixComposition: AVMutableComposition = AVMutableComposition()
        var mutableCompositionVideoTrack: [AVMutableCompositionTrack] = []
        var mutableCompositionAudioTrack: [AVMutableCompositionTrack] = []
        let totalVideoCompositionInstruction : AVMutableVideoCompositionInstruction = AVMutableVideoCompositionInstruction()
        
        let aVideoAsset: AVAsset = AVAsset(url: NSURL.fileURL(withPath: videoFile))
        let aAudioAsset: AVAsset = AVAsset(url: NSURL.fileURL(withPath: audioFile))
        
        if let videoTrack = mixComposition.addMutableTrack(withMediaType: .video, preferredTrackID: kCMPersistentTrackID_Invalid), let audioTrack = mixComposition.addMutableTrack(withMediaType: .audio, preferredTrackID: kCMPersistentTrackID_Invalid) {
            mutableCompositionVideoTrack.append(videoTrack)
            mutableCompositionAudioTrack.append(audioTrack)
            
            if let aVideoAssetTrack: AVAssetTrack = aVideoAsset.tracks(withMediaType: .video).first, let aAudioAssetTrack: AVAssetTrack = aAudioAsset.tracks(withMediaType: .audio).first {
                do {
                    try mutableCompositionVideoTrack.first?.insertTimeRange(CMTimeRangeMake(start: CMTime.zero, duration: aVideoAssetTrack.timeRange.duration), of: aVideoAssetTrack, at: CMTime.zero)
                    try mutableCompositionAudioTrack.first?.insertTimeRange(CMTimeRangeMake(start: CMTime.zero, duration: aVideoAssetTrack.timeRange.duration), of: aAudioAssetTrack, at: CMTime.zero)
                    videoTrack.preferredTransform = aVideoAssetTrack.preferredTransform
                    
                } catch{
                    print(error)
                }
                
                
                totalVideoCompositionInstruction.timeRange = CMTimeRangeMake(start: CMTime.zero,duration: aVideoAssetTrack.timeRange.duration)
            }
        }
        
        let mutableVideoComposition: AVMutableVideoComposition = AVMutableVideoComposition()
        mutableVideoComposition.frameDuration = CMTimeMake(value: 1, timescale: 30)
        mutableVideoComposition.renderSize = CGSize(width: 480, height: 640)
        
//        if NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first != nil {
            let outputURL = URL(fileURLWithPath: outputFile)
            
            do {
                if FileManager.default.fileExists(atPath: outputURL.path) {
                    
                    try FileManager.default.removeItem(at: outputURL)
                }
            } catch {
                result(FlutterError(code: "output_exist", message: "Output file delete error", details: nil))
            }
            
            if let exportSession = AVAssetExportSession(asset: mixComposition, presetName: AVAssetExportPresetHighestQuality) {
                exportSession.outputURL = outputURL
                exportSession.outputFileType = AVFileType.mp4
                exportSession.shouldOptimizeForNetworkUse = true
                
                /// try to export the file and handle the status cases
                exportSession.exportAsynchronously(completionHandler: {
                    switch exportSession.status {
                    case .failed:
                        if let _error = exportSession.error {
                            result(_error)
                        }
                        
                    case .cancelled:
                        if let _error = exportSession.error {
                            result(_error)
                        }
                        
                    default:
                        print("finished")
                        result(true)
                    }
                })
            } else {
                print("issue with avasset export session")
                result(false)
            }
//        }
//        print("issue with directory")
//        return result(false);
        
    }
}
