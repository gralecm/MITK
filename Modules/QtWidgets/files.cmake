file(GLOB_RECURSE H_FILES RELATIVE "${CMAKE_CURRENT_SOURCE_DIR}" "${CMAKE_CURRENT_SOURCE_DIR}/include/*")

set(CPP_FILES
QmitkApplicationCursor.cpp
QmitkDataStorageComboBox.cpp
QmitkDataStorageListModel.cpp
QmitkDataStorageTableModel.cpp
QmitkDataStorageTreeModel.cpp
QmitkEventAdapter.cpp
QmitkFileReaderOptionsDialog.cpp
QmitkFileReaderWriterOptionsWidget.cpp
QmitkFileWriterOptionsDialog.cpp
QmitkIOUtil.cpp
QmitkLevelWindowPresetDefinitionDialog.cpp
QmitkLevelWindowRangeChangeDialog.cpp
QmitkLevelWindowWidgetContextMenu.cpp
QmitkLevelWindowWidget.cpp
QmitkLineEditLevelWindowWidget.cpp
QmitkMemoryUsageIndicatorView.cpp
QmitkMimeTypes.cpp
QmitkNodeDescriptor.cpp
QmitkNodeDescriptorManager.cpp
QmitkRenderWindowMenu.cpp
QmitkProgressBar.cpp
QmitkPropertiesTableEditor.cpp
QmitkPropertiesTableModel.cpp
QmitkPropertyDelegate.cpp
QmitkRegisterClasses.cpp
QmitkRenderingManager.cpp
QmitkRenderingManagerFactory.cpp
QmitkRenderWindow.cpp
QmitkServiceListWidget.cpp
QmitkSliderLevelWindowWidget.cpp
QmitkStdMultiWidget.cpp
QmitkMouseModeSwitcher.cpp
QmitkDataStorageFilterProxyModel.cpp
QmitkDataStorageComboBoxWithSelectNone.cpp
)

set(MOC_H_FILES
  include/QmitkDataStorageComboBox.h
  include/QmitkDataStorageTableModel.h
  include/QmitkFileReaderOptionsDialog.h
  include/QmitkFileReaderWriterOptionsWidget.h
  include/QmitkFileWriterOptionsDialog.h
  include/QmitkLevelWindowPresetDefinitionDialog.h
  include/QmitkLevelWindowRangeChangeDialog.h
  include/QmitkLevelWindowWidgetContextMenu.h
  include/QmitkLevelWindowWidget.h
  include/QmitkLineEditLevelWindowWidget.h
  include/QmitkMemoryUsageIndicatorView.h
  include/QmitkNodeDescriptor.h
  include/QmitkNodeDescriptorManager.h
  include/QmitkRenderWindowMenu.h
  include/QmitkProgressBar.h
  include/QmitkPropertiesTableEditor.h
  include/QmitkPropertyDelegate.h
  include/QmitkRenderingManager.h
  include/QmitkRenderWindow.h
  include/QmitkServiceListWidget.h
  include/QmitkSliderLevelWindowWidget.h
  include/QmitkStdMultiWidget.h
  include/QmitkMouseModeSwitcher.h
  include/QmitkDataStorageComboBoxWithSelectNone.h
)

set(UI_FILES
  src/QmitkFileReaderOptionsDialog.ui
  src/QmitkFileWriterOptionsDialog.ui
  src/QmitkLevelWindowPresetDefinition.ui
  src/QmitkLevelWindowWidget.ui
  src/QmitkLevelWindowRangeChange.ui
  src/QmitkMemoryUsageIndicator.ui
  src/QmitkServiceListWidgetControls.ui
)

set(QRC_FILES
  resource/Qmitk.qrc
)
