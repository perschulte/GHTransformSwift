//
//  ViewController.swift
//  GHTransformSwift
//
//  Created by Per Schulte on 02.05.16.
//  Copyright © 2016 Per Schulte. All rights reserved.
//

import UIKit
import MetalKit
import MetalPerformanceShaders

class ViewController: UIViewController, MTKViewDelegate {

    @IBOutlet weak var metalView: MTKView!

    //Metal globals
    var commandQueue: MTLCommandQueue!
    var inTexture: MTLTexture!
    var gaussTexture: MTLTexture!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if !loadDefaultDevice() {
            return
        } else {
            loadAssets()
        }
    }
    
    private func loadDefaultDevice() -> Bool {
        
        // Load any resources required for rendering.
        metalView = view as? MTKView
        
        // Load default device.
        metalView.device = MTLCreateSystemDefaultDevice()
        
        // Make sure the current device supports MetalPerformanceShaders.
        guard let metalView = view as? MTKView where MPSSupportsMTLDevice(metalView.device) else { return false }

        // Setup view properties.
        metalView.delegate = self
        metalView.depthStencilPixelFormat = .Depth32Float_Stencil8
        
        // Set up pixel format as your input/output texture.
        metalView.colorPixelFormat = .BGRA8Unorm
        
        // Allow to access to `currentDrawable.texture` write mode.
        metalView.framebufferOnly = false

        return true
    }
    
    func loadAssets() {
        // Create new command queue.
        commandQueue = metalView.device!.newCommandQueue()
        
        // Load image into source texture for MetalPerformanceShaders.
        let textureLoader = MTKTextureLoader(device: metalView.device!)
        let url = NSBundle.mainBundle().URLForResource("cat", withExtension: "png")!
        
        do {
            inTexture = try textureLoader.newTextureWithContentsOfURL(url, options: [:])
            gaussTexture = try textureLoader.newTextureWithContentsOfURL(url, options: [:])
        }
        catch let error as NSError {
            fatalError("Unexpected error ocurred: \(error.localizedDescription).")
        }
    }

    func mtkView(view: MTKView, drawableSizeWillChange size: CGSize) {
        
    }
    
    func drawInMTKView(view: MTKView) {
        // Get command buffer to use in MetalPerformanceShaders.
        let commandBuffer = commandQueue.commandBuffer()
        
        // Initialize MetalPerformanceShaders gaussianBlur with Sigma = 10.0f.
        let gaussianblur = MPSImageGaussianBlur(device: view.device!, sigma: 10.0)
        let sobel = MPSImageSobel(device: view.device!)
        
        // Run MetalPerformanceShader `gaussianBlur`.
        gaussianblur.encodeToCommandBuffer(commandBuffer, sourceTexture: inTexture, destinationTexture: gaussTexture!)
        sobel.encodeToCommandBuffer(commandBuffer, sourceTexture: gaussTexture, destinationTexture: view.currentDrawable!.texture)
        
        // Finish `commandBuffer`.
        commandBuffer.presentDrawable(view.currentDrawable!)
        commandBuffer.commit()

    }
}

