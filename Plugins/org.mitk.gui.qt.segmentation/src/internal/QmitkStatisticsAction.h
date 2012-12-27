/*===================================================================

The Medical Imaging Interaction Toolkit (MITK)

Copyright (c) German Cancer Research Center,
Division of Medical and Biological Informatics.
All rights reserved.

This software is distributed WITHOUT ANY WARRANTY; without
even the implied warranty of MERCHANTABILITY or FITNESS FOR
A PARTICULAR PURPOSE.

See LICENSE.txt or http://www.mitk.org for details.

===================================================================*/
#ifndef QMITK_STATISTICSACTION_H
#define QMITK_STATISTICSACTION_H

#include <berryIWorkbenchPage.h>
#include "berryQtViewPart.h"

#include "mitkIContextMenuAction.h"

#include "org_mitk_gui_qt_segmentation_Export.h"

class QmitkStdMultiWidget;

class MITK_QT_SEGMENTATION QmitkStatisticsAction: public QObject, public mitk::IContextMenuAction
{
  Q_OBJECT
  Q_INTERFACES(mitk::IContextMenuAction)

public:

  QmitkStatisticsAction();
  virtual ~QmitkStatisticsAction();

  //interface methods
  void Run( const QList<mitk::DataNode::Pointer>& selectedNodes );
  void SetDataStorage(mitk::DataStorage* dataStorage);
  void SetSmoothed(bool smoothed);
  void SetDecimated(bool decimated);
  void SetFunctionality(berry::QtViewPart* functionality);

protected:

  //needs to be set over the IContextMenuAction (with this - QmitkDataManagerView - as parameter)
  berry::QtViewPart* m_BlueBerryView;
};
#endif // QMITK_STATISTICSACTION_H
