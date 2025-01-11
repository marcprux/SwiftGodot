//
// Generator's Plugin definition.swift
//
//
//  Created by Miguel de Icaza on 4/4/23.
//

import Foundation
import PackagePlugin

/// Generates the API for the SwiftGodot from the Godot exported Json API
@main struct SwiftCodeGeneratorPlugin: BuildToolPlugin {
    func createBuildCommands(context: PluginContext, target: Target) throws -> [Command] {
        var commands: [Command] = []
        // Configure the commands to write to a "GeneratedSources" directory.
        let genSourcesDir = context.pluginWorkDirectoryURL.appending(path: "GeneratedSources")

        // We only generate commands for source targets.
        let generator = try context.tool(named: "Generator").url

        let api = context.package.directoryURL
            .appending(["Sources", "ExtensionApi", "extension_api.json"])

        var arguments = [api.path, genSourcesDir.path]
        var outputFiles: [URL] = []
#if os(Windows)
        // Windows has 32K limit on CreateProcess argument length, SPM currently doesn't handle it well.
        // We generate so many output files that passing them all into the build command would exceed the limit.
        // So instead we combine the output into 26 swift files, one for each letter of the alphabet, each containing
        // all the types that start with that letter.
        let letters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
        for letter in letters {
            outputFiles.append(genSourcesDir.appending(path: "SwiftGodot\(letter).swift"))
        }
        arguments.append(context.package.directoryURL.appending(path: "doc").path)
        arguments.append("--combined")
        commands.append(
            Command.prebuildCommand(
                displayName: "Generating Swift API from \(api) to \(genSourcesDir)",
                executable: generator,
                arguments: arguments,
                outputFilesDirectory: genSourcesDir
            )
        )
#else
        outputFiles.append(contentsOf: knownBuiltin.map { genSourcesDir.appending(["generated-builtin", $0]) })
        outputFiles.append(contentsOf: known.map { genSourcesDir.appending(["generated", $0]) })
        commands.append(
            Command.buildCommand(
                displayName: "Generating Swift API from \(api) to \(genSourcesDir)",
                executable: generator,
                arguments: arguments,
                inputFiles: [api],
                outputFiles: outputFiles))
#endif

        return commands
    }
}

let knownBuiltin = [
  "AABB.swift",
  "Array.swift",
  "Basis.swift",
  "Callable.swift",
  "Color.swift",
  "core-defs.swift",
  "Dictionary.swift",
  "NodePath.swift",
  "PackedByteArray.swift",
  "PackedColorArray.swift",
  "PackedFloat32Array.swift",
  "PackedFloat64Array.swift",
  "PackedInt32Array.swift",
  "PackedInt64Array.swift",
  "PackedStringArray.swift",
  "PackedVector2Array.swift",
  "PackedVector3Array.swift",
  "PackedVector4Array.swift",
  "Plane.swift",
  "Projection.swift",
  "Quaternion.swift",
  "Rect2.swift",
  "Rect2i.swift",
  "RID.swift",
  "Signal.swift",
  "String.swift",
  "StringName.swift",
  "Transform2D.swift",
  "Transform3D.swift",
  "utility.swift",
  "Vector2.swift",
  "Vector2i.swift",
  "Vector3.swift",
  "Vector3i.swift",
  "Vector4.swift",
  "Vector4i.swift",
]

let known = [
  "AcceptDialog.swift",
  "AESContext.swift",
  "AnimatableBody2D.swift",
  "AnimatableBody3D.swift",
  "AnimatedSprite2D.swift",
  "AnimatedSprite3D.swift",
  "AnimatedTexture.swift",
  "Animation.swift",
  "AnimationLibrary.swift",
  "AnimationMixer.swift",
  "AnimationNode.swift",
  "AnimationNodeAdd2.swift",
  "AnimationNodeAdd3.swift",
  "AnimationNodeAnimation.swift",
  "AnimationNodeBlend2.swift",
  "AnimationNodeBlend3.swift",
  "AnimationNodeBlendSpace1D.swift",
  "AnimationNodeBlendSpace2D.swift",
  "AnimationNodeBlendTree.swift",
  "AnimationNodeOneShot.swift",
  "AnimationNodeOutput.swift",
  "AnimationNodeStateMachine.swift",
  "AnimationNodeStateMachinePlayback.swift",
  "AnimationNodeStateMachineTransition.swift",
  "AnimationNodeSub2.swift",
  "AnimationNodeSync.swift",
  "AnimationNodeTimeScale.swift",
  "AnimationNodeTimeSeek.swift",
  "AnimationNodeTransition.swift",
  "AnimationPlayer.swift",
  "AnimationRootNode.swift",
  "AnimationTree.swift",
  "Area2D.swift",
  "Area3D.swift",
  "ArrayMesh.swift",
  "ArrayOccluder3D.swift",
  "AspectRatioContainer.swift",
  "AStar2D.swift",
  "AStar3D.swift",
  "AStarGrid2D.swift",
  "AtlasTexture.swift",
  "AudioBusLayout.swift",
  "AudioEffect.swift",
  "AudioEffectAmplify.swift",
  "AudioEffectBandLimitFilter.swift",
  "AudioEffectBandPassFilter.swift",
  "AudioEffectCapture.swift",
  "AudioEffectChorus.swift",
  "AudioEffectCompressor.swift",
  "AudioEffectDelay.swift",
  "AudioEffectDistortion.swift",
  "AudioEffectEQ.swift",
  "AudioEffectEQ6.swift",
  "AudioEffectEQ10.swift",
  "AudioEffectEQ21.swift",
  "AudioEffectFilter.swift",
  "AudioEffectHardLimiter.swift",
  "AudioEffectHighPassFilter.swift",
  "AudioEffectHighShelfFilter.swift",
  "AudioEffectInstance.swift",
  "AudioEffectLimiter.swift",
  "AudioEffectLowPassFilter.swift",
  "AudioEffectLowShelfFilter.swift",
  "AudioEffectNotchFilter.swift",
  "AudioEffectPanner.swift",
  "AudioEffectPhaser.swift",
  "AudioEffectPitchShift.swift",
  "AudioEffectRecord.swift",
  "AudioEffectReverb.swift",
  "AudioEffectSpectrumAnalyzer.swift",
  "AudioEffectSpectrumAnalyzerInstance.swift",
  "AudioEffectStereoEnhance.swift",
  "AudioListener2D.swift",
  "AudioListener3D.swift",
  "AudioSample.swift",
  "AudioSamplePlayback.swift",
  "AudioServer.swift",
  "AudioStream.swift",
  "AudioStreamGenerator.swift",
  "AudioStreamGeneratorPlayback.swift",
  "AudioStreamInteractive.swift",
  "AudioStreamMicrophone.swift",
  "AudioStreamMP3.swift",
  "AudioStreamOggVorbis.swift",
  "AudioStreamPlayback.swift",
  "AudioStreamPlaybackInteractive.swift",
  "AudioStreamPlaybackOggVorbis.swift",
  "AudioStreamPlaybackPlaylist.swift",
  "AudioStreamPlaybackPolyphonic.swift",
  "AudioStreamPlaybackResampled.swift",
  "AudioStreamPlaybackSynchronized.swift",
  "AudioStreamPlayer.swift",
  "AudioStreamPlayer2D.swift",
  "AudioStreamPlayer3D.swift",
  "AudioStreamPlaylist.swift",
  "AudioStreamPolyphonic.swift",
  "AudioStreamRandomizer.swift",
  "AudioStreamSynchronized.swift",
  "AudioStreamWAV.swift",
  "BackBufferCopy.swift",
  "BaseButton.swift",
  "BaseMaterial3D.swift",
  "BitMap.swift",
  "Bone2D.swift",
  "BoneAttachment3D.swift",
  "BoneMap.swift",
  "BoxContainer.swift",
  "BoxMesh.swift",
  "BoxOccluder3D.swift",
  "BoxShape3D.swift",
  "Button.swift",
  "ButtonGroup.swift",
  "CallbackTweener.swift",
  "Camera2D.swift",
  "Camera3D.swift",
  "CameraAttributes.swift",
  "CameraAttributesPhysical.swift",
  "CameraAttributesPractical.swift",
  "CameraFeed.swift",
  "CameraServer.swift",
  "CameraTexture.swift",
  "CanvasGroup.swift",
  "CanvasItem.swift",
  "CanvasItemMaterial.swift",
  "CanvasLayer.swift",
  "CanvasModulate.swift",
  "CanvasTexture.swift",
  "CapsuleMesh.swift",
  "CapsuleShape2D.swift",
  "CapsuleShape3D.swift",
  "CenterContainer.swift",
  "CharacterBody2D.swift",
  "CharacterBody3D.swift",
  "CharFXTransform.swift",
  "CheckBox.swift",
  "CheckButton.swift",
  "CircleShape2D.swift",
  "ClassDB.swift",
  "CodeEdit.swift",
  "CodeHighlighter.swift",
  "CollisionObject2D.swift",
  "CollisionObject3D.swift",
  "CollisionPolygon2D.swift",
  "CollisionPolygon3D.swift",
  "CollisionShape2D.swift",
  "CollisionShape3D.swift",
  "ColorPicker.swift",
  "ColorPickerButton.swift",
  "ColorRect.swift",
  "Compositor.swift",
  "CompositorEffect.swift",
  "CompressedCubemap.swift",
  "CompressedCubemapArray.swift",
  "CompressedTexture2D.swift",
  "CompressedTexture2DArray.swift",
  "CompressedTexture3D.swift",
  "CompressedTextureLayered.swift",
  "ConcavePolygonShape2D.swift",
  "ConcavePolygonShape3D.swift",
  "ConeTwistJoint3D.swift",
  "ConfigFile.swift",
  "ConfirmationDialog.swift",
  "Container.swift",
  "Control.swift",
  "ConvexPolygonShape2D.swift",
  "ConvexPolygonShape3D.swift",
  "CPUParticles2D.swift",
  "CPUParticles3D.swift",
  "Crypto.swift",
  "CryptoKey.swift",
  "CSGBox3D.swift",
  "CSGCombiner3D.swift",
  "CSGCylinder3D.swift",
  "CSGMesh3D.swift",
  "CSGPolygon3D.swift",
  "CSGPrimitive3D.swift",
  "CSGShape3D.swift",
  "CSGSphere3D.swift",
  "CSGTorus3D.swift",
  "Cubemap.swift",
  "CubemapArray.swift",
  "Curve.swift",
  "Curve2D.swift",
  "Curve3D.swift",
  "CurveTexture.swift",
  "CurveXYZTexture.swift",
  "CylinderMesh.swift",
  "CylinderShape3D.swift",
  "DampedSpringJoint2D.swift",
  "Decal.swift",
  "DirAccess.swift",
  "DirectionalLight2D.swift",
  "DirectionalLight3D.swift",
  "DisplayServer.swift",
  "DTLSServer.swift",
  "EditorCommandPalette.swift",
  "EditorDebuggerPlugin.swift",
  "EditorDebuggerSession.swift",
  "EditorExportPlatform.swift",
  "EditorExportPlatformAndroid.swift",
  "EditorExportPlatformIOS.swift",
  "EditorExportPlatformLinuxBSD.swift",
  "EditorExportPlatformMacOS.swift",
  "EditorExportPlatformPC.swift",
  "EditorExportPlatformWeb.swift",
  "EditorExportPlatformWindows.swift",
  "EditorExportPlugin.swift",
  "EditorFeatureProfile.swift",
  "EditorFileDialog.swift",
  "EditorFileSystem.swift",
  "EditorFileSystemDirectory.swift",
  "EditorFileSystemImportFormatSupportQuery.swift",
  "EditorImportPlugin.swift",
  "EditorInspector.swift",
  "EditorInspectorPlugin.swift",
  "EditorInterface.swift",
  "EditorNode3DGizmo.swift",
  "EditorNode3DGizmoPlugin.swift",
  "EditorPaths.swift",
  "EditorPlugin.swift",
  "EditorProperty.swift",
  "EditorResourceConversionPlugin.swift",
  "EditorResourcePicker.swift",
  "EditorResourcePreview.swift",
  "EditorResourcePreviewGenerator.swift",
  "EditorResourceTooltipPlugin.swift",
  "EditorSceneFormatImporter.swift",
  "EditorSceneFormatImporterBlend.swift",
  "EditorSceneFormatImporterFBX2GLTF.swift",
  "EditorSceneFormatImporterGLTF.swift",
  "EditorSceneFormatImporterUFBX.swift",
  "EditorScenePostImport.swift",
  "EditorScenePostImportPlugin.swift",
  "EditorScript.swift",
  "EditorScriptPicker.swift",
  "EditorSelection.swift",
  "EditorSettings.swift",
  "EditorSpinSlider.swift",
  "EditorSyntaxHighlighter.swift",
  "EditorTranslationParserPlugin.swift",
  "EditorUndoRedoManager.swift",
  "EditorVCSInterface.swift",
  "EncodedObjectAsID.swift",
  "ENetConnection.swift",
  "ENetMultiplayerPeer.swift",
  "ENetPacketPeer.swift",
  "Engine.swift",
  "EngineDebugger.swift",
  "EngineProfiler.swift",
  "Environment.swift",
  "Expression.swift",
  "FastNoiseLite.swift",
  "FBXDocument.swift",
  "FBXState.swift",
  "FileAccess.swift",
  "FileDialog.swift",
  "FileSystemDock.swift",
  "FlowContainer.swift",
  "FogMaterial.swift",
  "FogVolume.swift",
  "Font.swift",
  "FontFile.swift",
  "FontVariation.swift",
  "FramebufferCacheRD.swift",
  "GDExtension.swift",
  "GDExtensionManager.swift",
  "GDScript.swift",
  "Generic6DOFJoint3D.swift",
  "Geometry2D.swift",
  "Geometry3D.swift",
  "GeometryInstance3D.swift",
  "GLTFAccessor.swift",
  "GLTFAnimation.swift",
  "GLTFBufferView.swift",
  "GLTFCamera.swift",
  "GLTFDocument.swift",
  "GLTFDocumentExtension.swift",
  "GLTFDocumentExtensionConvertImporterMesh.swift",
  "GLTFLight.swift",
  "GLTFMesh.swift",
  "GLTFNode.swift",
  "GLTFPhysicsBody.swift",
  "GLTFPhysicsShape.swift",
  "GLTFSkeleton.swift",
  "GLTFSkin.swift",
  "GLTFSpecGloss.swift",
  "GLTFState.swift",
  "GLTFTexture.swift",
  "GLTFTextureSampler.swift",
  "GPUParticles2D.swift",
  "GPUParticles3D.swift",
  "GPUParticlesAttractor3D.swift",
  "GPUParticlesAttractorBox3D.swift",
  "GPUParticlesAttractorSphere3D.swift",
  "GPUParticlesAttractorVectorField3D.swift",
  "GPUParticlesCollision3D.swift",
  "GPUParticlesCollisionBox3D.swift",
  "GPUParticlesCollisionHeightField3D.swift",
  "GPUParticlesCollisionSDF3D.swift",
  "GPUParticlesCollisionSphere3D.swift",
  "Gradient.swift",
  "GradientTexture1D.swift",
  "GradientTexture2D.swift",
  "GraphEdit.swift",
  "GraphElement.swift",
  "GraphFrame.swift",
  "GraphNode.swift",
  "GridContainer.swift",
  "GridMap.swift",
  "GrooveJoint2D.swift",
  "HashingContext.swift",
  "HBoxContainer.swift",
  "HeightMapShape3D.swift",
  "HFlowContainer.swift",
  "HingeJoint3D.swift",
  "HMACContext.swift",
  "HScrollBar.swift",
  "HSeparator.swift",
  "HSlider.swift",
  "HSplitContainer.swift",
  "HTTPClient.swift",
  "HTTPRequest.swift",
  "Image.swift",
  "ImageFormatLoader.swift",
  "ImageFormatLoaderExtension.swift",
  "ImageTexture.swift",
  "ImageTexture3D.swift",
  "ImageTextureLayered.swift",
  "ImmediateMesh.swift",
  "ImporterMesh.swift",
  "ImporterMeshInstance3D.swift",
  "Input.swift",
  "InputEvent.swift",
  "InputEventAction.swift",
  "InputEventFromWindow.swift",
  "InputEventGesture.swift",
  "InputEventJoypadButton.swift",
  "InputEventJoypadMotion.swift",
  "InputEventKey.swift",
  "InputEventMagnifyGesture.swift",
  "InputEventMIDI.swift",
  "InputEventMouse.swift",
  "InputEventMouseButton.swift",
  "InputEventMouseMotion.swift",
  "InputEventPanGesture.swift",
  "InputEventScreenDrag.swift",
  "InputEventScreenTouch.swift",
  "InputEventShortcut.swift",
  "InputEventWithModifiers.swift",
  "InputMap.swift",
  "InstancePlaceholder.swift",
  "IntervalTweener.swift",
  "IP.swift",
  "ItemList.swift",
  "JavaClass.swift",
  "JavaClassWrapper.swift",
  "JavaScriptBridge.swift",
  "JavaScriptObject.swift",
  "JNISingleton.swift",
  "Joint2D.swift",
  "Joint3D.swift",
  "JSON.swift",
  "JSONRPC.swift",
  "KinematicCollision2D.swift",
  "KinematicCollision3D.swift",
  "Label.swift",
  "Label3D.swift",
  "LabelSettings.swift",
  "Light2D.swift",
  "Light3D.swift",
  "LightmapGI.swift",
  "LightmapGIData.swift",
  "Lightmapper.swift",
  "LightmapperRD.swift",
  "LightmapProbe.swift",
  "LightOccluder2D.swift",
  "Line2D.swift",
  "LineEdit.swift",
  "LinkButton.swift",
  "MainLoop.swift",
  "MarginContainer.swift",
  "Marker2D.swift",
  "Marker3D.swift",
  "Marshalls.swift",
  "Material.swift",
  "MenuBar.swift",
  "MenuButton.swift",
  "Mesh.swift",
  "MeshConvexDecompositionSettings.swift",
  "MeshDataTool.swift",
  "MeshInstance2D.swift",
  "MeshInstance3D.swift",
  "MeshLibrary.swift",
  "MeshTexture.swift",
  "MethodTweener.swift",
  "MissingNode.swift",
  "MissingResource.swift",
  "MobileVRInterface.swift",
  "MovieWriter.swift",
  "MultiMesh.swift",
  "MultiMeshInstance2D.swift",
  "MultiMeshInstance3D.swift",
  "MultiplayerAPI.swift",
  "MultiplayerAPIExtension.swift",
  "MultiplayerPeer.swift",
  "MultiplayerPeerExtension.swift",
  "MultiplayerSpawner.swift",
  "MultiplayerSynchronizer.swift",
  "Mutex.swift",
  "NativeMenu.swift",
  "NavigationAgent2D.swift",
  "NavigationAgent3D.swift",
  "NavigationLink2D.swift",
  "NavigationLink3D.swift",
  "NavigationMesh.swift",
  "NavigationMeshGenerator.swift",
  "NavigationMeshSourceGeometryData2D.swift",
  "NavigationMeshSourceGeometryData3D.swift",
  "NavigationObstacle2D.swift",
  "NavigationObstacle3D.swift",
  "NavigationPathQueryParameters2D.swift",
  "NavigationPathQueryParameters3D.swift",
  "NavigationPathQueryResult2D.swift",
  "NavigationPathQueryResult3D.swift",
  "NavigationPolygon.swift",
  "NavigationRegion2D.swift",
  "NavigationRegion3D.swift",
  "NavigationServer2D.swift",
  "NavigationServer3D.swift",
  "NinePatchRect.swift",
  "Node.swift",
  "Node2D.swift",
  "Node3D.swift",
  "Node3DGizmo.swift",
  "Noise.swift",
  "NoiseTexture2D.swift",
  "NoiseTexture3D.swift",
  "Object.swift",
  "Occluder3D.swift",
  "OccluderInstance3D.swift",
  "OccluderPolygon2D.swift",
  "OfflineMultiplayerPeer.swift",
  "OggPacketSequence.swift",
  "OggPacketSequencePlayback.swift",
  "OmniLight3D.swift",
  "OpenXRAction.swift",
  "OpenXRActionMap.swift",
  "OpenXRActionSet.swift",
  "OpenXRAPIExtension.swift",
  "OpenXRCompositionLayer.swift",
  "OpenXRCompositionLayerCylinder.swift",
  "OpenXRCompositionLayerEquirect.swift",
  "OpenXRCompositionLayerQuad.swift",
  "OpenXRExtensionWrapperExtension.swift",
  "OpenXRHand.swift",
  "OpenXRInteractionProfile.swift",
  "OpenXRInteractionProfileMetadata.swift",
  "OpenXRInterface.swift",
  "OpenXRIPBinding.swift",
  "OptimizedTranslation.swift",
  "OptionButton.swift",
  "ORMMaterial3D.swift",
  "OS.swift",
  "PackedDataContainer.swift",
  "PackedDataContainerRef.swift",
  "PackedScene.swift",
  "PacketPeer.swift",
  "PacketPeerDTLS.swift",
  "PacketPeerExtension.swift",
  "PacketPeerStream.swift",
  "PacketPeerUDP.swift",
  "Panel.swift",
  "PanelContainer.swift",
  "PanoramaSkyMaterial.swift",
  "Parallax2D.swift",
  "ParallaxBackground.swift",
  "ParallaxLayer.swift",
  "ParticleProcessMaterial.swift",
  "Path2D.swift",
  "Path3D.swift",
  "PathFollow2D.swift",
  "PathFollow3D.swift",
  "PCKPacker.swift",
  "Performance.swift",
  "PhysicalBone2D.swift",
  "PhysicalBone3D.swift",
  "PhysicalBoneSimulator3D.swift",
  "PhysicalSkyMaterial.swift",
  "PhysicsBody2D.swift",
  "PhysicsBody3D.swift",
  "PhysicsDirectBodyState2D.swift",
  "PhysicsDirectBodyState2DExtension.swift",
  "PhysicsDirectBodyState3D.swift",
  "PhysicsDirectBodyState3DExtension.swift",
  "PhysicsDirectSpaceState2D.swift",
  "PhysicsDirectSpaceState2DExtension.swift",
  "PhysicsDirectSpaceState3D.swift",
  "PhysicsDirectSpaceState3DExtension.swift",
  "PhysicsMaterial.swift",
  "PhysicsPointQueryParameters2D.swift",
  "PhysicsPointQueryParameters3D.swift",
  "PhysicsRayQueryParameters2D.swift",
  "PhysicsRayQueryParameters3D.swift",
  "PhysicsServer2D.swift",
  "PhysicsServer2DExtension.swift",
  "PhysicsServer2DManager.swift",
  "PhysicsServer3D.swift",
  "PhysicsServer3DExtension.swift",
  "PhysicsServer3DManager.swift",
  "PhysicsServer3DRenderingServerHandler.swift",
  "PhysicsShapeQueryParameters2D.swift",
  "PhysicsShapeQueryParameters3D.swift",
  "PhysicsTestMotionParameters2D.swift",
  "PhysicsTestMotionParameters3D.swift",
  "PhysicsTestMotionResult2D.swift",
  "PhysicsTestMotionResult3D.swift",
  "PinJoint2D.swift",
  "PinJoint3D.swift",
  "PlaceholderCubemap.swift",
  "PlaceholderCubemapArray.swift",
  "PlaceholderMaterial.swift",
  "PlaceholderMesh.swift",
  "PlaceholderTexture2D.swift",
  "PlaceholderTexture2DArray.swift",
  "PlaceholderTexture3D.swift",
  "PlaceholderTextureLayered.swift",
  "PlaneMesh.swift",
  "PointLight2D.swift",
  "PointMesh.swift",
  "Polygon2D.swift",
  "PolygonOccluder3D.swift",
  "PolygonPathFinder.swift",
  "Popup.swift",
  "PopupMenu.swift",
  "PopupPanel.swift",
  "PortableCompressedTexture2D.swift",
  "PrimitiveMesh.swift",
  "PrismMesh.swift",
  "ProceduralSkyMaterial.swift",
  "ProgressBar.swift",
  "ProjectSettings.swift",
  "PropertyTweener.swift",
  "QuadMesh.swift",
  "QuadOccluder3D.swift",
  "RandomNumberGenerator.swift",
  "Range.swift",
  "RayCast2D.swift",
  "RayCast3D.swift",
  "RDAttachmentFormat.swift",
  "RDFramebufferPass.swift",
  "RDPipelineColorBlendState.swift",
  "RDPipelineColorBlendStateAttachment.swift",
  "RDPipelineDepthStencilState.swift",
  "RDPipelineMultisampleState.swift",
  "RDPipelineRasterizationState.swift",
  "RDPipelineSpecializationConstant.swift",
  "RDSamplerState.swift",
  "RDShaderFile.swift",
  "RDShaderSource.swift",
  "RDShaderSPIRV.swift",
  "RDTextureFormat.swift",
  "RDTextureView.swift",
  "RDUniform.swift",
  "RDVertexAttribute.swift",
  "RectangleShape2D.swift",
  "RefCounted.swift",
  "ReferenceRect.swift",
  "ReflectionProbe.swift",
  "RegEx.swift",
  "RegExMatch.swift",
  "RemoteTransform2D.swift",
  "RemoteTransform3D.swift",
  "RenderData.swift",
  "RenderDataExtension.swift",
  "RenderDataRD.swift",
  "RenderingDevice.swift",
  "RenderingServer.swift",
  "RenderSceneBuffers.swift",
  "RenderSceneBuffersConfiguration.swift",
  "RenderSceneBuffersExtension.swift",
  "RenderSceneBuffersRD.swift",
  "RenderSceneData.swift",
  "RenderSceneDataExtension.swift",
  "RenderSceneDataRD.swift",
  "Resource.swift",
  "ResourceFormatLoader.swift",
  "ResourceFormatSaver.swift",
  "ResourceImporter.swift",
  "ResourceImporterBitMap.swift",
  "ResourceImporterBMFont.swift",
  "ResourceImporterCSVTranslation.swift",
  "ResourceImporterDynamicFont.swift",
  "ResourceImporterImage.swift",
  "ResourceImporterImageFont.swift",
  "ResourceImporterLayeredTexture.swift",
  "ResourceImporterMP3.swift",
  "ResourceImporterOBJ.swift",
  "ResourceImporterOggVorbis.swift",
  "ResourceImporterScene.swift",
  "ResourceImporterShaderFile.swift",
  "ResourceImporterTexture.swift",
  "ResourceImporterTextureAtlas.swift",
  "ResourceImporterWAV.swift",
  "ResourceLoader.swift",
  "ResourcePreloader.swift",
  "ResourceSaver.swift",
  "ResourceUID.swift",
  "RibbonTrailMesh.swift",
  "RichTextEffect.swift",
  "RichTextLabel.swift",
  "RigidBody2D.swift",
  "RigidBody3D.swift",
  "RootMotionView.swift",
  "SceneMultiplayer.swift",
  "SceneReplicationConfig.swift",
  "SceneState.swift",
  "SceneTree.swift",
  "SceneTreeTimer.swift",
  "Script.swift",
  "ScriptCreateDialog.swift",
  "ScriptEditor.swift",
  "ScriptEditorBase.swift",
  "ScriptExtension.swift",
  "ScriptLanguage.swift",
  "ScriptLanguageExtension.swift",
  "ScrollBar.swift",
  "ScrollContainer.swift",
  "SegmentShape2D.swift",
  "Semaphore.swift",
  "SeparationRayShape2D.swift",
  "SeparationRayShape3D.swift",
  "Separator.swift",
  "Shader.swift",
  "ShaderGlobalsOverride.swift",
  "ShaderInclude.swift",
  "ShaderMaterial.swift",
  "Shape2D.swift",
  "Shape3D.swift",
  "ShapeCast2D.swift",
  "ShapeCast3D.swift",
  "Shortcut.swift",
  "Skeleton2D.swift",
  "Skeleton3D.swift",
  "SkeletonIK3D.swift",
  "SkeletonModification2D.swift",
  "SkeletonModification2DCCDIK.swift",
  "SkeletonModification2DFABRIK.swift",
  "SkeletonModification2DJiggle.swift",
  "SkeletonModification2DLookAt.swift",
  "SkeletonModification2DPhysicalBones.swift",
  "SkeletonModification2DStackHolder.swift",
  "SkeletonModification2DTwoBoneIK.swift",
  "SkeletonModificationStack2D.swift",
  "SkeletonModifier3D.swift",
  "SkeletonProfile.swift",
  "SkeletonProfileHumanoid.swift",
  "Skin.swift",
  "SkinReference.swift",
  "Sky.swift",
  "Slider.swift",
  "SliderJoint3D.swift",
  "SoftBody3D.swift",
  "SphereMesh.swift",
  "SphereOccluder3D.swift",
  "SphereShape3D.swift",
  "SpinBox.swift",
  "SplitContainer.swift",
  "SpotLight3D.swift",
  "SpringArm3D.swift",
  "Sprite2D.swift",
  "Sprite3D.swift",
  "SpriteBase3D.swift",
  "SpriteFrames.swift",
  "StandardMaterial3D.swift",
  "StaticBody2D.swift",
  "StaticBody3D.swift",
  "StatusIndicator.swift",
  "StreamPeer.swift",
  "StreamPeerBuffer.swift",
  "StreamPeerExtension.swift",
  "StreamPeerGZIP.swift",
  "StreamPeerTCP.swift",
  "StreamPeerTLS.swift",
  "StyleBox.swift",
  "StyleBoxEmpty.swift",
  "StyleBoxFlat.swift",
  "StyleBoxLine.swift",
  "StyleBoxTexture.swift",
  "SubViewport.swift",
  "SubViewportContainer.swift",
  "SurfaceTool.swift",
  "SyntaxHighlighter.swift",
  "SystemFont.swift",
  "TabBar.swift",
  "TabContainer.swift",
  "TCPServer.swift",
  "TextEdit.swift",
  "TextLine.swift",
  "TextMesh.swift",
  "TextParagraph.swift",
  "TextServer.swift",
  "TextServerAdvanced.swift",
  "TextServerDummy.swift",
  "TextServerExtension.swift",
  "TextServerManager.swift",
  "Texture.swift",
  "Texture2D.swift",
  "Texture2DArray.swift",
  "Texture2DArrayRD.swift",
  "Texture2DRD.swift",
  "Texture3D.swift",
  "Texture3DRD.swift",
  "TextureButton.swift",
  "TextureCubemapArrayRD.swift",
  "TextureCubemapRD.swift",
  "TextureLayered.swift",
  "TextureLayeredRD.swift",
  "TextureProgressBar.swift",
  "TextureRect.swift",
  "Theme.swift",
  "ThemeDB.swift",
  "Thread.swift",
  "TileData.swift",
  "TileMap.swift",
  "TileMapLayer.swift",
  "TileMapPattern.swift",
  "TileSet.swift",
  "TileSetAtlasSource.swift",
  "TileSetScenesCollectionSource.swift",
  "TileSetSource.swift",
  "Time.swift",
  "Timer.swift",
  "TLSOptions.swift",
  "TorusMesh.swift",
  "TouchScreenButton.swift",
  "Translation.swift",
  "TranslationServer.swift",
  "Tree.swift",
  "TreeItem.swift",
  "TriangleMesh.swift",
  "TubeTrailMesh.swift",
  "Tween.swift",
  "Tweener.swift",
  "UDPServer.swift",
  "UndoRedo.swift",
  "UniformSetCacheRD.swift",
  "UPNP.swift",
  "UPNPDevice.swift",
  "VBoxContainer.swift",
  "VehicleBody3D.swift",
  "VehicleWheel3D.swift",
  "VFlowContainer.swift",
  "VideoStream.swift",
  "VideoStreamPlayback.swift",
  "VideoStreamPlayer.swift",
  "VideoStreamTheora.swift",
  "Viewport.swift",
  "ViewportTexture.swift",
  "VisibleOnScreenEnabler2D.swift",
  "VisibleOnScreenEnabler3D.swift",
  "VisibleOnScreenNotifier2D.swift",
  "VisibleOnScreenNotifier3D.swift",
  "VisualInstance3D.swift",
  "VisualShader.swift",
  "VisualShaderNode.swift",
  "VisualShaderNodeBillboard.swift",
  "VisualShaderNodeBooleanConstant.swift",
  "VisualShaderNodeBooleanParameter.swift",
  "VisualShaderNodeClamp.swift",
  "VisualShaderNodeColorConstant.swift",
  "VisualShaderNodeColorFunc.swift",
  "VisualShaderNodeColorOp.swift",
  "VisualShaderNodeColorParameter.swift",
  "VisualShaderNodeComment.swift",
  "VisualShaderNodeCompare.swift",
  "VisualShaderNodeConstant.swift",
  "VisualShaderNodeCubemap.swift",
  "VisualShaderNodeCubemapParameter.swift",
  "VisualShaderNodeCurveTexture.swift",
  "VisualShaderNodeCurveXYZTexture.swift",
  "VisualShaderNodeCustom.swift",
  "VisualShaderNodeDerivativeFunc.swift",
  "VisualShaderNodeDeterminant.swift",
  "VisualShaderNodeDistanceFade.swift",
  "VisualShaderNodeDotProduct.swift",
  "VisualShaderNodeExpression.swift",
  "VisualShaderNodeFaceForward.swift",
  "VisualShaderNodeFloatConstant.swift",
  "VisualShaderNodeFloatFunc.swift",
  "VisualShaderNodeFloatOp.swift",
  "VisualShaderNodeFloatParameter.swift",
  "VisualShaderNodeFrame.swift",
  "VisualShaderNodeFresnel.swift",
  "VisualShaderNodeGlobalExpression.swift",
  "VisualShaderNodeGroupBase.swift",
  "VisualShaderNodeIf.swift",
  "VisualShaderNodeInput.swift",
  "VisualShaderNodeIntConstant.swift",
  "VisualShaderNodeIntFunc.swift",
  "VisualShaderNodeIntOp.swift",
  "VisualShaderNodeIntParameter.swift",
  "VisualShaderNodeIs.swift",
  "VisualShaderNodeLinearSceneDepth.swift",
  "VisualShaderNodeMix.swift",
  "VisualShaderNodeMultiplyAdd.swift",
  "VisualShaderNodeOuterProduct.swift",
  "VisualShaderNodeOutput.swift",
  "VisualShaderNodeParameter.swift",
  "VisualShaderNodeParameterRef.swift",
  "VisualShaderNodeParticleAccelerator.swift",
  "VisualShaderNodeParticleBoxEmitter.swift",
  "VisualShaderNodeParticleConeVelocity.swift",
  "VisualShaderNodeParticleEmit.swift",
  "VisualShaderNodeParticleEmitter.swift",
  "VisualShaderNodeParticleMeshEmitter.swift",
  "VisualShaderNodeParticleMultiplyByAxisAngle.swift",
  "VisualShaderNodeParticleOutput.swift",
  "VisualShaderNodeParticleRandomness.swift",
  "VisualShaderNodeParticleRingEmitter.swift",
  "VisualShaderNodeParticleSphereEmitter.swift",
  "VisualShaderNodeProximityFade.swift",
  "VisualShaderNodeRandomRange.swift",
  "VisualShaderNodeRemap.swift",
  "VisualShaderNodeReroute.swift",
  "VisualShaderNodeResizableBase.swift",
  "VisualShaderNodeRotationByAxis.swift",
  "VisualShaderNodeSample3D.swift",
  "VisualShaderNodeScreenNormalWorldSpace.swift",
  "VisualShaderNodeScreenUVToSDF.swift",
  "VisualShaderNodeSDFRaymarch.swift",
  "VisualShaderNodeSDFToScreenUV.swift",
  "VisualShaderNodeSmoothStep.swift",
  "VisualShaderNodeStep.swift",
  "VisualShaderNodeSwitch.swift",
  "VisualShaderNodeTexture.swift",
  "VisualShaderNodeTexture2DArray.swift",
  "VisualShaderNodeTexture2DArrayParameter.swift",
  "VisualShaderNodeTexture2DParameter.swift",
  "VisualShaderNodeTexture3D.swift",
  "VisualShaderNodeTexture3DParameter.swift",
  "VisualShaderNodeTextureParameter.swift",
  "VisualShaderNodeTextureParameterTriplanar.swift",
  "VisualShaderNodeTextureSDF.swift",
  "VisualShaderNodeTextureSDFNormal.swift",
  "VisualShaderNodeTransformCompose.swift",
  "VisualShaderNodeTransformConstant.swift",
  "VisualShaderNodeTransformDecompose.swift",
  "VisualShaderNodeTransformFunc.swift",
  "VisualShaderNodeTransformOp.swift",
  "VisualShaderNodeTransformParameter.swift",
  "VisualShaderNodeTransformVecMult.swift",
  "VisualShaderNodeUIntConstant.swift",
  "VisualShaderNodeUIntFunc.swift",
  "VisualShaderNodeUIntOp.swift",
  "VisualShaderNodeUIntParameter.swift",
  "VisualShaderNodeUVFunc.swift",
  "VisualShaderNodeUVPolarCoord.swift",
  "VisualShaderNodeVarying.swift",
  "VisualShaderNodeVaryingGetter.swift",
  "VisualShaderNodeVaryingSetter.swift",
  "VisualShaderNodeVec2Constant.swift",
  "VisualShaderNodeVec2Parameter.swift",
  "VisualShaderNodeVec3Constant.swift",
  "VisualShaderNodeVec3Parameter.swift",
  "VisualShaderNodeVec4Constant.swift",
  "VisualShaderNodeVec4Parameter.swift",
  "VisualShaderNodeVectorBase.swift",
  "VisualShaderNodeVectorCompose.swift",
  "VisualShaderNodeVectorDecompose.swift",
  "VisualShaderNodeVectorDistance.swift",
  "VisualShaderNodeVectorFunc.swift",
  "VisualShaderNodeVectorLen.swift",
  "VisualShaderNodeVectorOp.swift",
  "VisualShaderNodeVectorRefract.swift",
  "VisualShaderNodeWorldPositionFromDepth.swift",
  "VoxelGI.swift",
  "VoxelGIData.swift",
  "VScrollBar.swift",
  "VSeparator.swift",
  "VSlider.swift",
  "VSplitContainer.swift",
  "WeakRef.swift",
  "WebRTCDataChannel.swift",
  "WebRTCDataChannelExtension.swift",
  "WebRTCMultiplayerPeer.swift",
  "WebRTCPeerConnection.swift",
  "WebRTCPeerConnectionExtension.swift",
  "WebSocketMultiplayerPeer.swift",
  "WebSocketPeer.swift",
  "WebXRInterface.swift",
  "Window.swift",
  "WorkerThreadPool.swift",
  "World2D.swift",
  "World3D.swift",
  "WorldBoundaryShape2D.swift",
  "WorldBoundaryShape3D.swift",
  "WorldEnvironment.swift",
  "X509Certificate.swift",
  "XMLParser.swift",
  "XRAnchor3D.swift",
  "XRBodyModifier3D.swift",
  "XRBodyTracker.swift",
  "XRCamera3D.swift",
  "XRController3D.swift",
  "XRControllerTracker.swift",
  "XRFaceModifier3D.swift",
  "XRFaceTracker.swift",
  "XRHandModifier3D.swift",
  "XRHandTracker.swift",
  "XRInterface.swift",
  "XRInterfaceExtension.swift",
  "XRNode3D.swift",
  "XROrigin3D.swift",
  "XRPose.swift",
  "XRPositionalTracker.swift",
  "XRServer.swift",
  "XRTracker.swift",
  "XRVRS.swift",
  "ZIPPacker.swift",
  "ZIPReader.swift",

]

extension URL {
    func appending(_ paths: [String]) -> URL {
        return paths.reduce(self) { $0.appending(path: $1) }
    }
}
