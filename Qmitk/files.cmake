SET(CPP_FILES
  plugin/plugin_QmitkUndoRedoButton.cpp
  popupactionhistory.cpp
  popupundoredo.cpp
  QmitkAlgorithmFunctionalityComponent.cpp
  QmitkApplicationBase/QmitkApplicationCursor.cpp
  QmitkApplicationBase/QmitkCommonFunctionality.cpp
  QmitkApplicationBase/QmitkFctMediator.cpp
  QmitkApplicationBase/QmitkFunctionality.cpp
  QmitkApplicationBase/QmitkFunctionalityFactory.cpp
  QmitkApplicationBase/QmitkFunctionalityTesting.cpp
  QmitkApplicationBase/QmitkSaveProjectWidget.cpp
  QmitkBaseAlgorithmComponent.cpp
  QmitkBaseFunctionalityComponent.cpp
  QmitkCallbackFromGUIThread.cpp
  QmitkColorTransferFunctionCanvas.cpp
  QmitkFctCompMediator.cpp
  QmitkFunctionalityComponentContainer.cpp
  QmitkFunctionalityComponents/QmitkConnectivityFilterComponent.cpp
  QmitkFunctionalityComponents/QmitkPixelGreyValueManipulatorComponent.cpp
  QmitkFunctionalityComponents/QmitkSeedPointSetComponent.cpp
  QmitkFunctionalityComponents/QmitkSliceSliderNavigationComponent.cpp
  QmitkFunctionalityComponents/QmitkSurfaceCreatorComponent.cpp
  QmitkFunctionalityComponents/QmitkThresholdComponent.cpp
  QmitkHelpBrowser.cpp
  QmitkInteractionFunctionalityComponent.cpp
  QmitkLevelWindowWidgetContextMenu.cpp
  QmitkLineEditLevelWindowWidget.cpp
  QmitkPiecewiseFunctionCanvas.cpp
  QmitkProgressBar.cpp
  QmitkPropertyListViewItem.cpp
  QmitkPropertyListViewItemFactory.cpp
  QmitkPropertyObservers/PropertyViewTestWidget.cpp
  QmitkPropertyObservers/QmitkBasePropertyView.cpp
  QmitkPropertyObservers/QmitkBoolPropertyEditor.cpp
  QmitkPropertyObservers/QmitkBoolPropertyView.cpp
  QmitkPropertyObservers/QmitkColorPropertyEditor.cpp
  QmitkPropertyObservers/QmitkColorPropertyView.cpp
  QmitkPropertyObservers/QmitkDataTreeComboBox.cpp
  QmitkPropertyObservers/QmitkDataTreeListView.cpp
  QmitkPropertyObservers/QmitkDataTreeListViewExpander.cpp
  QmitkPropertyObservers/QmitkNumberPropertyEditor.cpp
  QmitkPropertyObservers/QmitkNumberPropertyView.cpp
  QmitkPropertyObservers/QmitkPropertyViewFactory.cpp
  QmitkPropertyObservers/QmitkStringPropertyEditor.cpp
  QmitkPropertyObservers/QmitkStringPropertyOnDemandEdit.cpp
  QmitkPropertyObservers/QmitkStringPropertyView.cpp
  QmitkRenderingManager.cpp
  QmitkRenderingManagerFactory.cpp
  QmitkRenderWindow.cpp
  QmitkSliderLevelWindowWidget.cpp
  QmitkStatusBar.cpp
  QmitkStepperAdapter.cpp
  QmitkTransferFunctionCanvas.cpp
  QmitkUndoRedoButton.cpp
  QmitkVideoBackground.cpp
  qundoredobutton.cpp
  VtkQRenderWindowInteractor.cpp
)
SET(UI_FILES
  QmitkApplicationBase/QmitkControlsLeftFctLayoutTemplate.ui
  QmitkApplicationBase/QmitkControlsRightFctLayoutTemplate.ui
  QmitkApplicationBase/QmitkMainTemplate.ui
  QmitkApplicationBase/QmitkRawImageFileOpener.ui
  QmitkApplicationBase/QmitkRawImageFileSequenceOpener.ui
  QmitkApplicationBase/QmitkNablaBase.ui
  QmitkApplicationBase/QmitkOptionDialog.ui
  QmitkApplicationBase/QmitkRenderWindowSelector.ui
  QmitkApplicationBase/QmitkSystemInfo.ui
  QmitkApplicationBase/QmitkTreeNodeSelector.ui
  QmitkFunctionalityComponentContainerGUI.ui
  QmitkFunctionalityComponents/QmitkConnectivityFilterComponentGUI.ui
  QmitkFunctionalityComponents/QmitkPixelGreyValueManipulatorComponentGUI.ui
  QmitkFunctionalityComponents/QmitkSeedPointSetComponentGUI.ui
  QmitkFunctionalityComponents/QmitkSliceSliderNavigationComponentGUI.ui
  QmitkFunctionalityComponents/QmitkSurfaceCreatorComponentGUI.ui
  QmitkFunctionalityComponents/QmitkThresholdComponentGUI.ui
  QmitkLevelWindowPresetDefinition.ui
  QmitkLevelWindowRangeChange.ui
  QmitkLevelWindowWidget.ui
  QmitkMaterialEditor.ui
  QmitkMaterialShowcase.ui
  QmitkPointListWidget.ui
  QmitkPrimitiveMovieNavigator.ui
  QmitkPropertyListView.ui
  QmitkSelectableGLWidget.ui
  QmitkSliceWidget.ui
  QmitkSliderNavigator.ui
  QmitkStdMultiWidget.ui
  QmitkTransferFunctionWidget.ui
  QmitkTwoButtonNavigator.ui
  QmitkVolumetryWidget.ui
)
SET(MOC_H_FILES
  popupactionhistory.h
  popupundoredo.h
  QmitkAlgorithmFunctionalityComponent.h
  QmitkApplicationBase/QmitkFctMediator.h
  QmitkApplicationBase/QmitkFunctionality.h
  QmitkApplicationBase/QmitkFunctionalityTesting.h
  QmitkApplicationBase/QmitkSaveProjectWidget.h
  QmitkBaseFunctionalityComponent.h
  QmitkCallbackFromGUIThread.h
  QmitkColorTransferFunctionCanvas.h
  QmitkFctCompMediator.h
  QmitkFunctionalityComponentContainer.h
  QmitkFunctionalityComponents/QmitkConnectivityFilterComponent.h
  QmitkFunctionalityComponents/QmitkPixelGreyValueManipulatorComponent.h
  QmitkFunctionalityComponents/QmitkSeedPointSetComponent.h
  QmitkFunctionalityComponents/QmitkSliceSliderNavigationComponent.h
  QmitkFunctionalityComponents/QmitkSurfaceCreatorComponent.h
  QmitkFunctionalityComponents/QmitkThresholdComponent.h
  QmitkHelpBrowser.h
  QmitkInteractionFunctionalityComponent.h
  QmitkLevelWindowWidgetContextMenu.h
  QmitkLineEditLevelWindowWidget.h
  QmitkPiecewiseFunctionCanvas.h
  QmitkPropertyListViewItem.h
  QmitkPropertyObservers/PropertyViewTestWidget.h
  QmitkPropertyObservers/QmitkBasePropertyView.h
  QmitkPropertyObservers/QmitkBoolPropertyEditor.h
  QmitkPropertyObservers/QmitkBoolPropertyView.h
  QmitkPropertyObservers/QmitkColorPropertyEditor.h
  QmitkPropertyObservers/QmitkColorPropertyView.h
  QmitkPropertyObservers/QmitkDataTreeComboBox.h
  QmitkPropertyObservers/QmitkDataTreeListViewExpander.h
  QmitkPropertyObservers/QmitkDataTreeListView.h
  QmitkPropertyObservers/QmitkNumberPropertyEditor.h
  QmitkPropertyObservers/QmitkNumberPropertyView.h
  QmitkPropertyObservers/QmitkStringPropertyEditor.h
  QmitkPropertyObservers/QmitkStringPropertyOnDemandEdit.h
  QmitkPropertyObservers/QmitkStringPropertyView.h
  QmitkRenderingManager.h
  QmitkSliderLevelWindowWidget.h
  QmitkStepperAdapter.h
  QmitkTransferFunctionCanvas.h
  QmitkUndoRedoButton.h
  QmitkVideoBackground.h
  qundoredobutton.h
)
