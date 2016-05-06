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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if !loadDefaultDevice() {
            return
        } else {
            
        }
    }
    
    private func loadDefaultDevice() -> Bool {
        // Load default device.
        metalView.device = MTLCreateSystemDefaultDevice()
        
        // Make sure the current device supports MetalPerformanceShaders.
        guard let metalView = view as? MTKView where MPSSupportsMTLDevice(metalView.device) else { return false }

        // Setup view properties.
        metalView.delegate = self
        metalView.depthStencilPixelFormat = .Depth32Float_Stencil8
        
        // Set up pixel format as your input/output texture.
        metalView.colorPixelFormat = .RGBA16Uint
        
        // Allow to access to `currentDrawable.texture` write mode.
        metalView.framebufferOnly = false

        
        return true
    }
    
    func mtkView(view: MTKView, drawableSizeWillChange size: CGSize) {
        
    }
    
    func drawInMTKView(view: MTKView) {
        
    }
}

