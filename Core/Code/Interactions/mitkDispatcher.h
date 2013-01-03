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

#ifndef mitkDispatcher_h
#define mitkDispatcher_h

#include "itkObject.h"
#include "itkObjectFactory.h"
#include "mitkEvent.h" //
#include "mitkCommon.h"
#include "mitkDataNode.h"
#include "mitkDataInteractor.h"
#include <MitkExports.h>
#include <list>

/**
 * Receives Events (Mouse-,Key-, ... Events) and dispatches them to the registered DataInteractor Objects.
 * The order in which DataInteractors are offered to handle an event is determined by layer of their associated DataNode.
 * Higher layers are preferred.
 */


namespace mitk
{

  enum ProcessEventMode { REGULAR, GRABINPUT, PREFERINPUT, CONNECTEDMOUSEACTION };
  class InteractionEvent;
  class MITK_CORE_EXPORT Dispatcher : public itk::Object {

  public:
    mitkClassMacro(Dispatcher, itk::Object);
    itkNewMacro(Self);

    typedef std::list<DataInteractor::Pointer> ListInteractorType;

    /**
     * To post new Events which are to be handled by the Dispatcher.
     *
     * @return Returns true if the event has been handled by an DataInteractor, and false else.
     */
    bool ProcessEvent(InteractionEvent* event);
    /**
     * Adds the DataInteractor that is associated with the DataNode to the Dispatcher Queue.
     * If there already exists an DataInteractor that has a reference to the same DataNode, it is removed.
     * Note that within this method also all other DataInteractor are checked and and removed if they are no longer active,
     * but were not removed properly.
     */
    void AddDataInteractor(const DataNode* dataNode);
    /**
     * Remove all DataInteractors related to this Node, to prevent double entries and dead references.
     */
    void RemoveDataInteractor(const DataNode* dataNode);
    size_t GetNumberOfInteractors(); // DEBUG TESTING

  protected:
    Dispatcher();
    virtual ~Dispatcher();

  private:
    std::list<DataInteractor::Pointer> m_Interactors;
    /**
     * Removes ALL related Interactors, this is necessary especially when DataNode is assigned to new Interactor
     */
    void RemoveOrphanedInteractors();

    /**
     * A ConnectedMouseAction is described by the sequence of Mouse-Press, [Mouse-Move] , Mouse-Release Events.
     * Within this sequence all events are sent to the same Interactor, namely the one which received the event from the Mouse-Press action.
     * m_ConnectedMouseAction  - is set to true, when a Mouse-Down Event occurs and an interactor takes the events,
     * m_SelectedInteractor contains said interactor.
     * m_ConnectedMouseAction is reset to false, after the Mouse-Release Event occurs,
     * while it is true, the m_SelectedInteractor is the only one that receives Mouse-Events.
     */
    ProcessEventMode m_ProcessingMode;
    DataInteractor::Pointer m_SelectedInteractor;

    void SetEventProcessingMode(DataInteractor::Pointer);


  };

} /* namespace mitk */
#endif /* mitkDispatcher_h */
