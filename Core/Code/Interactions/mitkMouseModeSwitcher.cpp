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


#include "mitkMouseModeSwitcher.h"

#include "mitkDisplayInteractor.h"
#include "mitkDisplayVectorInteractor.h"
#include "mitkDisplayVectorInteractorLevelWindow.h"
#include "mitkDisplayVectorInteractorScroll.h"



mitk::MouseModeSwitcher::MouseModeSwitcher( mitk::GlobalInteraction* gi ) 
: m_GlobalInteraction( gi )
, m_ActiveInteractionScheme( MITK )
, m_ActiveMouseMode( MousePointer )
, m_LeftMouseButtonHandler( NULL )
{
  assert(gi);

  this->InitializeListeners();
  this->SetInteractionScheme( m_ActiveInteractionScheme );
}


mitk::MouseModeSwitcher::~MouseModeSwitcher()
{
}


void mitk::MouseModeSwitcher::InitializeListeners()
{
  mitk::DisplayVectorInteractor::Pointer moveAndZoomInteractor = mitk::DisplayVectorInteractor::New(
    "moveNzoom", new mitk::DisplayInteractor() );
  mitk::StateMachine::Pointer listener = moveAndZoomInteractor.GetPointer();
  m_ListenersForMITK.push_back( listener );


  mitk::DisplayVectorInteractorScroll::Pointer scrollInteractor = mitk::DisplayVectorInteractorScroll::New( 
    "alternativeScroll", new mitk::DisplayInteractor() );
  listener = scrollInteractor;
  m_ListenersForPACS.push_back( listener );

  mitk::DisplayVectorInteractorLevelWindow::Pointer lwInteractor = mitk::DisplayVectorInteractorLevelWindow::New("alternativeLevelWindow");
  listener = lwInteractor;
  m_ListenersForPACS.push_back( listener );

  mitk::DisplayVectorInteractor::Pointer panInteractor = mitk::DisplayVectorInteractor::New( 
    "alternativePan", new mitk::DisplayInteractor() );
  listener = panInteractor;
  m_ListenersForPACS.push_back( listener );

  mitk::DisplayVectorInteractor::Pointer crtlZoomInteractor = mitk::DisplayVectorInteractor::New( 
    "alternativeZoom", new mitk::DisplayInteractor() );
  listener = crtlZoomInteractor;
  m_ListenersForPACS.push_back( listener );


}

void mitk::MouseModeSwitcher::SetInteractionScheme( InteractionScheme scheme )
{

  switch ( scheme )
  {
  case MITK :
    {
      ListenerList::iterator iter;
      for ( iter=m_ListenersForPACS.begin(); iter!=m_ListenersForPACS.end(); iter++ )
      {
        m_GlobalInteraction->RemoveListener( (*iter) );
      }

      for ( iter=m_ListenersForMITK.begin(); iter!=m_ListenersForMITK.end(); iter++ )
      {
        m_GlobalInteraction->AddListener( (*iter) );
      }
      break;
    } // case MITK
  case PACS :
    {
      ListenerList::iterator iter;
      for ( iter=m_ListenersForMITK.begin(); iter!=m_ListenersForMITK.end(); iter++ )
      {
        m_GlobalInteraction->RemoveListener( (*iter) );
      }

      for ( iter=m_ListenersForPACS.begin(); iter!=m_ListenersForPACS.end(); iter++ )
      {
        m_GlobalInteraction->AddListener( (*iter) );
      }

      this->SelectMouseMode( MousePointer );
      break;
    } // case PACS
  case OFF:
    {
      ListenerList::iterator iter;
      for ( iter=m_ListenersForMITK.begin(); iter!=m_ListenersForMITK.end(); iter++ )
      {
        m_GlobalInteraction->RemoveListener( (*iter) );
      }
      for ( iter=m_ListenersForPACS.begin(); iter!=m_ListenersForPACS.end(); iter++ )
      {
        m_GlobalInteraction->RemoveListener( (*iter) );
      }
      break;
    } // case OFF
  } // switch


  m_ActiveInteractionScheme = scheme;
}

mitk::MouseModeSwitcher::InteractionScheme mitk::MouseModeSwitcher::GetInteractionScheme() const
{
  return m_ActiveInteractionScheme;
}

void mitk::MouseModeSwitcher::SelectMouseMode( MouseMode mode )
{
  if ( m_ActiveInteractionScheme != PACS )
    return;

  switch ( mode )
  {
  case MousePointer :
    {
      m_GlobalInteraction->RemoveListener( m_LeftMouseButtonHandler );
      break;
    } // case 0
  case Scroll :
    {
      m_GlobalInteraction->RemoveListener( m_LeftMouseButtonHandler );

      mitk::DisplayVectorInteractorScroll::Pointer scrollInteractor = mitk::DisplayVectorInteractorScroll::New( 
        "Scroll", new mitk::DisplayInteractor() );
      m_LeftMouseButtonHandler = scrollInteractor;

      m_GlobalInteraction->AddListener( m_LeftMouseButtonHandler );

      break;
    } // case 1
  case LevelWindow :
    {
      m_GlobalInteraction->RemoveListener( m_LeftMouseButtonHandler );

      mitk::DisplayVectorInteractorLevelWindow::Pointer lwInteractor = mitk::DisplayVectorInteractorLevelWindow::New( 
        "LevelWindow" );
      m_LeftMouseButtonHandler = lwInteractor;

      m_GlobalInteraction->AddListener( m_LeftMouseButtonHandler );

      break;
    } // case 2
  case Zoom :
    {
      m_GlobalInteraction->RemoveListener( m_LeftMouseButtonHandler );

      mitk::DisplayVectorInteractor::Pointer zoomInteractor = mitk::DisplayVectorInteractor::New( 
        "Zoom", new mitk::DisplayInteractor() );
      m_LeftMouseButtonHandler = zoomInteractor;

      m_GlobalInteraction->AddListener( m_LeftMouseButtonHandler );

      break;
    } // case 3
  case Pan :
    {
      m_GlobalInteraction->RemoveListener( m_LeftMouseButtonHandler );

      mitk::DisplayVectorInteractor::Pointer panInteractor = mitk::DisplayVectorInteractor::New( 
        "Pan", new mitk::DisplayInteractor() );
      m_LeftMouseButtonHandler = panInteractor;

      m_GlobalInteraction->AddListener( m_LeftMouseButtonHandler );

      break;
    } // case 4

  } // switch (mode)

  m_ActiveMouseMode = mode;

  this->InvokeEvent( MouseModeChangedEvent() );

}


mitk::MouseModeSwitcher::MouseMode mitk::MouseModeSwitcher::GetCurrentMouseMode() const
{
  return m_ActiveMouseMode;
}


