/*===================================================================

BlueBerry Platform

Copyright (c) German Cancer Research Center,
Division of Medical and Biological Informatics.
All rights reserved.

This software is distributed WITHOUT ANY WARRANTY; without
even the implied warranty of MERCHANTABILITY or FITNESS FOR
A PARTICULAR PURPOSE.

See LICENSE.txt or http://www.mitk.org for details.

===================================================================*/

#ifndef BERRYCOMMANDMANAGER_H_
#define BERRYCOMMANDMANAGER_H_

#include "common/berryHandleObjectManager.h"

#include "berryIExecutionListenerWithChecks.h"
#include "berryICommandListener.h"
#include "berryIParameterTypeListener.h"
#include "berryICommandCategoryListener.h"
#include "berryICommandManagerListener.h"

#include <map>

namespace berry
{

struct IParameter;
struct IHandler;
class ParameterType;
class ParameterizedCommand;
class Parameterization;
class Command;
class CommandCategory;

/**
 * <p>
 * A central repository for commands -- both in the defined and undefined
 * states. Commands can be created and retrieved using this manager. It is
 * possible to listen to changes in the collection of commands by attaching a
 * listener to the manager.
 * </p>
 *
 * @see CommandManager#getCommand(String)
 * @since 3.1
 */
class BERRY_COMMANDS CommandManager: public HandleObjectManager
{

private:

  typedef HandleObjectManager::HandleObjectsSet HandleObjectsSet;
  typedef HandleObjectManager::HandleObjectsByIdMap HandleObjectsByIdMap;

  /**
   * A listener that forwards incoming execution events to execution listeners
   * on this manager. The execution events will come from any command on this
   * manager.
   *
   * @since 3.1
   */
  struct ExecutionListener: public IExecutionListenerWithChecks
  {

    ExecutionListener(CommandManager* commandManager);

    void NotDefined(const std::string& commandId,
        const NotDefinedException* exception);

    void NotEnabled(const std::string& commandId,
        const NotEnabledException* exception);

    void NotHandled(const std::string& commandId,
        const NotHandledException* exception);

    void PostExecuteFailure(const std::string& commandId,
        const ExecutionException* exception);

    void PostExecuteSuccess(const std::string& commandId,
        const Object::Pointer returnValue);

    void PreExecute(const std::string& commandId, const SmartPointer<
        const ExecutionEvent> event);

  private:

    CommandManager* commandManager;
  };

  struct CommandCategoryListener: public ICommandCategoryListener
  {

    CommandCategoryListener(CommandManager* commandManager);

    void CategoryChanged(
        const SmartPointer<const CommandCategoryEvent> categoryEvent);

  private:

    CommandManager* commandManager;
  };

  ICommandCategoryListener::Pointer categoryListener;

  struct CommandListener: public ICommandListener
  {

    CommandListener(CommandManager* commandManager);

    void CommandChanged(const SmartPointer<const CommandEvent> commandEvent);

  private:

    CommandManager* commandManager;

  };

  ICommandListener::Pointer commandListener;

  struct ParameterTypeListener: public IParameterTypeListener
  {

    ParameterTypeListener(CommandManager* commandManager);

    void ParameterTypeChanged(
        const SmartPointer<const ParameterTypeEvent> parameterTypeEvent);

  private:

    CommandManager* commandManager;

  };

  IParameterTypeListener::Pointer parameterTypeListener;

public:

  /**
   * The identifier of the category in which all auto-generated commands will
   * appear. This value must never be <code>null</code>.
   *
   * @since 3.2
   */
  static const std::string AUTOGENERATED_CATEGORY_ID; // = "org.blueberry.core.commands.categories.autogenerated";

  /**
   * The default constructor
   */
  CommandManager();

  /**
   * Adds a listener to this command manager. The listener will be notified
   * when the set of defined commands changes. This can be used to track the
   * global appearance and disappearance of commands.
   *
   * @param listener
   *            The listener to attach; must not be <code>null</code>.
   */
  void AddCommandManagerListener(
      const SmartPointer<ICommandManagerListener> listener);

  /**
   * Adds an execution listener to this manager. This listener will be
   * notified if any of the commands controlled by this manager execute. This
   * can be used to support macros and instrumentation of commands.
   *
   * @param listener
   *            The listener to attach; must not be <code>null</code>.
   */
  void AddExecutionListener(const SmartPointer<IExecutionListener> listener);

  /**
   * Sets the name and description of the category for uncategorized commands.
   * This is the category that will be returned if
   * {@link #getCategory(String)} is called with <code>null</code>.
   *
   * @param name
   *            The name of the category for uncategorized commands; must not
   *            be <code>null</code>.
   * @param description
   *            The description of the category for uncategorized commands;
   *            may be <code>null</code>.
   * @since 3.2
   */
  void DefineUncategorizedCategory(const std::string& name,
      const std::string& description);

  /**
   * <p>
   * Returns a {@link ParameterizedCommand} with a command and
   * parameterizations as specified in the provided
   * <code>serializedParameterizedCommand</code> string. The
   * <code>serializedParameterizedCommand</code> must use the format
   * returned by {@link ParameterizedCommand#serialize()} and described in the
   * Javadoc for that method.
   * </p>
   * <p>
   * If a parameter id encoded in the
   * <code>serializedParameterizedCommand</code> does not exist in the
   * encoded command, that parameter id and value are ignored. A given
   * parameter id should not be used more than once in
   * <code>serializedParameterizedCommand</code>. This will not result in
   * an exception, but in this case the value of the parameter when the
   * command is executed is unspecified.
   * </p>
   * <p>
   * This method will never return <code>null</code>, however it may throw
   * an exception if there is a problem processing the serialization string or
   * the encoded command is undefined.
   * </p>
   *
   * @param serializedParameterizedCommand
   *            a string representing a command id and parameter ids and
   *            values; must not be <code>null</code>
   * @return a {@link ParameterizedCommand} with the command and
   *         parameterizations encoded in the
   *         <code>serializedParameterizedCommand</code>; never
   *         <code>null</code>.
   * @throws NotDefinedException
   *             if the command indicated in
   *             <code>serializedParameterizedCommand</code> is not defined
   * @throws SerializationException
   *             if there is an error deserializing
   *             <code>serializedParameterizedCommand</code>
   * @see ParameterizedCommand#serialize()
   * @since 3.2
   */
  SmartPointer<ParameterizedCommand> Deserialize(
      const std::string& serializedParameterizedCommand)
      throw(NotDefinedException, SerializationException);

  /**
   * Returns all of the commands known by this manager -- defined and
   * undefined.
   *
   * @return All of the commands; may be empty, but never <code>null</code>.
   * @since 3.2
   */
  std::vector<SmartPointer<Command> > GetAllCommands() const;

  /**
   * Gets the category with the given identifier. If no such category
   * currently exists, then the category will be created (but be undefined).
   *
   * @param categoryId
   *            The identifier to find; must not be <code>null</code>. If
   *            the category is <code>null</code>, then a category suitable
   *            for uncategorized items is defined and returned.
   * @return The category with the given identifier; this value will never be
   *         <code>null</code>, but it might be undefined.
   * @see Category
   */
  SmartPointer<CommandCategory> GetCategory(const std::string& categoryId);

  /**
   * Gets the command with the given identifier. If no such command currently
   * exists, then the command will be created (but will be undefined).
   *
   * @param commandId
   *            The identifier to find; must not be <code>null</code> and
   *            must not be zero-length.
   * @return The command with the given identifier; this value will never be
   *         <code>null</code>, but it might be undefined.
   * @see Command
   */
  SmartPointer<Command> GetCommand(const std::string& commandId);

  /**
   * Returns the categories that are defined.
   *
   * @return The defined categories; this value may be empty, but it is never
   *         <code>null</code>.
   * @since 3.2
   */
  std::vector<SmartPointer<CommandCategory> > GetDefinedCategories();

  /**
   * Returns the set of identifiers for those category that are defined.
   *
   * @return The set of defined category identifiers; this value may be empty,
   *         but it is never <code>null</code>.
   */
  Poco::HashSet<std::string> GetDefinedCategoryIds() const;

  /**
   * Returns the set of identifiers for those commands that are defined.
   *
   * @return The set of defined command identifiers; this value may be empty,
   *         but it is never <code>null</code>.
   */
  Poco::HashSet<std::string> GetDefinedCommandIds() const;

  /**
   * Returns the commands that are defined.
   *
   * @return The defined commands; this value may be empty, but it is never
   *         <code>null</code>.
   * @since 3.2
   */
  std::vector<SmartPointer<Command> > GetDefinedCommands() const;

  /**
   * Returns the set of identifiers for those parameter types that are
   * defined.
   *
   * @return The set of defined command parameter type identifiers; this value
   *         may be empty, but it is never <code>null</code>.
   * @since 3.2
   */
  Poco::HashSet<std::string> GetDefinedParameterTypeIds() const;

  /**
   * Returns the command parameter types that are defined.
   *
   * @return The defined command parameter types; this value may be empty, but
   *         it is never <code>null</code>.
   * @since 3.2
   */
  std::vector<SmartPointer<ParameterType> > GetDefinedParameterTypes();

  /**
   * Gets the help context identifier for a particular command. The command's
   * handler is first checked for a help context identifier. If the handler
   * does not have a help context identifier, then the help context identifier
   * for the command is returned. If neither has a help context identifier,
   * then <code>null</code> is returned.
   *
   * @param command
   *            The command for which the help context should be retrieved;
   *            must not be <code>null</code>.
   * @return The help context identifier to use for the given command; may be
   *         <code>null</code>.
   * @throws NotDefinedException
   *             If the given command is not defined.
   * @since 3.2
   */
  std::string GetHelpContextId(const SmartPointer<const Command> command) const
      throw(NotDefinedException);

  /**
   * Gets the command {@link ParameterType} with the given identifier. If no
   * such command parameter type currently exists, then the command parameter
   * type will be created (but will be undefined).
   *
   * @param parameterTypeId
   *            The identifier to find; must not be <code>null</code> and
   *            must not be zero-length.
   * @return The {@link ParameterType} with the given identifier; this value
   *         will never be <code>null</code>, but it might be undefined.
   * @since 3.2
   */
  SmartPointer<ParameterType> GetParameterType(
      const std::string& parameterTypeId);

  /**
   * Removes a listener from this command manager.
   *
   * @param listener
   *            The listener to be removed; must not be <code>null</code>.
   */
  void RemoveCommandManagerListener(
      const SmartPointer<ICommandManagerListener> listener);

  /**
   * Removes an execution listener from this command manager.
   *
   * @param listener
   *            The listener to be removed; must not be <code>null</code>.
   */
  void RemoveExecutionListener(const SmartPointer<IExecutionListener> listener);

  /**
   * Block updates all of the handlers for all of the commands. If the handler
   * is <code>null</code> or the command id does not exist in the map, then
   * the command becomes unhandled. Otherwise, the handler is set to the
   * corresponding value in the map.
   *
   * @param handlersByCommandId
   *            A map of command identifiers (<code>String</code>) to
   *            handlers (<code>IHandler</code>). This map may be
   *            <code>null</code> if all handlers should be cleared.
   *            Similarly, if the map is empty, then all commands will become
   *            unhandled.
   */
  void SetHandlersByCommandId(
      const std::map<std::string, SmartPointer<IHandler> >& handlersByCommandId);

  /**
   * Sets the help context identifier to associate with a particular handler.
   *
   * @param handler
   *            The handler with which to register a help context identifier;
   *            must not be <code>null</code>.
   * @param helpContextId
   *            The help context identifier to register; may be
   *            <code>null</code> if the help context identifier should be
   *            removed.
   * @since 3.2
   */
  void SetHelpContextId(const SmartPointer<IHandler> handler,
      const std::string& helpContextId);

  /**
   * Fires the <code>notEnabled</code> event for
   * <code>executionListeners</code>.
   * <p>
   * <b>Note:</b> This supports bridging actions to the command framework,
   * and should not be used outside the framework.
   * </p>
   *
   * @param commandId
   *            The command id of the command about to execute, never
   *            <code>null</code>.
   * @param exception
   *            The exception, never <code>null</code>.
   * @since 3.4
   */
  void FireNotEnabled(const std::string& commandId,
      const NotEnabledException* exception);

  /**
   * Fires the <code>notDefined</code> event for
   * <code>executionListeners</code>.
   * <p>
   * <b>Note:</b> This supports bridging actions to the command framework,
   * and should not be used outside the framework.
   * </p>
   *
   * @param commandId
   *            The command id of the command about to execute, never
   *            <code>null</code>.
   * @param exception
   *            The exception, never <code>null</code>.
   * @since 3.4
   */
  void FireNotDefined(const std::string& commandId,
      const NotDefinedException* exception);

  /**
   * Fires the <code>preExecute</code> event for
   * <code>executionListeners</code>.
   * <p>
   * <b>Note:</b> This supports bridging actions to the command framework,
   * and should not be used outside the framework.
   * </p>
   *
   * @param commandId
   *            The command id of the command about to execute, never
   *            <code>null</code>.
   * @param event
   *            The event that triggered the command, may be <code>null</code>.
   * @since 3.4
   */
  void FirePreExecute(const std::string& commandId, const SmartPointer<
      const ExecutionEvent> event);

  /**
   * Fires the <code>postExecuteSuccess</code> event for
   * <code>executionListeners</code>.
   * <p>
   * <b>Note:</b> This supports bridging actions to the command framework,
   * and should not be used outside the framework.
   * </p>
   *
   * @param commandId
   *            The command id of the command executed, never
   *            <code>null</code>.
   * @param returnValue
   *            The value returned from the command, may be <code>null</code>.
   * @since 3.4
   */
  void FirePostExecuteSuccess(const std::string& commandId,
      Object::Pointer returnValue);

  /**
   * Fires the <code>postExecuteFailure</code> event for
   * <code>executionListeners</code>.
   * <p>
   * <b>Note:</b> This supports bridging actions to the command framework,
   * and should not be used outside the framework.
   * </p>
   *
   * @param commandId
   *            The command id of the command executed, never
   *            <code>null</code>.
   * @param exception
   *            The exception, never <code>null</code>.
   * @since 3.4
   */
  void FirePostExecuteFailure(const std::string& commandId,
      const ExecutionException* exception);

protected:

  /**
   * The escape character to use for serialization and deserialization of
   * parameterized commands.
   */
  static const char ESCAPE_CHAR; // = '%';

  /**
   * The character that separates a parameter id from its value.
   */
  static const char ID_VALUE_CHAR; // = '=';

  /**
   * The character that indicates the end of a list of parameters.
   */
  static const char PARAMETER_END_CHAR; // = ')';

  /**
   * The character that separators parameters from each other.
   */
  static const char PARAMETER_SEPARATOR_CHAR; // = ',';

  /**
   * The character that indicates the start of a list of parameters.
   */
  static const char PARAMETER_START_CHAR; // = '(';

  friend class ParameterizedCommand;

private:

  /**
   * Unescapes special characters in the command id, parameter ids and
   * parameter values for {@link #deserialize(String)}. The special characters
   * {@link #PARAMETER_START_CHAR}, {@link #PARAMETER_END_CHAR},
   * {@link #ID_VALUE_CHAR}, {@link #PARAMETER_SEPARATOR_CHAR} and
   * {@link #ESCAPE_CHAR} are escaped by prepending an {@link #ESCAPE_CHAR}
   * character.
   * <p>
   * See also ParameterizedCommand.escape(String)
   * </p>
   *
   * @param escapedText
   *            a <code>String</code> that may contain escaped special
   *            characters for command serialization.
   * @return a <code>String</code> representing <code>escapedText</code>
   *         with any escaped characters replaced by their literal values
   * @throws SerializationException
   *             if <code>escapedText</code> contains an invalid escape
   *             sequence
   * @since 3.2
   */
  static std::string Unescape(const std::string& escapedText)
      throw(SerializationException);

  /**
   * The map of category identifiers (<code>String</code>) to categories (
   * <code>Category</code>). This collection may be empty, but it is never
   * <code>null</code>.
   */
  Poco::HashMap<std::string, SmartPointer<CommandCategory> > categoriesById;

  /**
   * The set of identifiers for those categories that are defined. This value
   * may be empty, but it is never <code>null</code>.
   */
  Poco::HashSet<std::string> definedCategoryIds;

  /**
   * The set of identifiers for those command parameter types that are
   * defined. This value may be empty, but it is never <code>null</code>.
   *
   * @since 3.2
   */
  Poco::HashSet<std::string> definedParameterTypeIds;

  /**
   * The execution listener for this command manager. This just forwards
   * events from commands controlled by this manager to listeners on this
   * manager.
   */
  SmartPointer<IExecutionListenerWithChecks> executionListener;

  /**
   * The collection of execution listeners. This collection is
   * <code>null</code> if there are no listeners.
   */
  IExecutionListenerWithChecks::Events executionEvents;

  /**
   *
   */
  ICommandManagerListener::Events commandManagerEvents;

  /**
   * The help context identifiers ({@link String}) for a handler ({@link IHandler}).
   * This map may be empty, but it is never <code>null</code>. Entries are
   * removed if all strong references to the handler are removed.
   *
   * @since 3.2
   */
  Poco::HashMap<WeakPointer<IHandler>, std::string, Object::Hash>
      helpContextIdsByHandler;

  /**
   * The map of parameter type identifiers (<code>String</code>) to
   * parameter types ( <code>ParameterType</code>). This collection may be
   * empty, but it is never <code>null</code>.
   *
   * @since 3.2
   */
  Poco::HashMap<std::string, SmartPointer<ParameterType> > parameterTypesById;

  /**
   * Notifies all of the listeners to this manager that the set of defined
   * command identifiers has changed.
   *
   * @param event
   *            The event to send to all of the listeners; must not be
   *            <code>null</code>.
   */
  void FireCommandManagerChanged(
      const SmartPointer<const CommandManagerEvent> event);

  /**
   * Returns an array of parameterizations for the provided command by
   * deriving the parameter ids and values from the provided
   * <code>serializedParameters</code> string.
   *
   * @param serializedParameters
   *            a String encoding parameter ids and values; must not be
   *            <code>null</code>.
   * @param parameters
   *            array of parameters of the command being deserialized; may be
   *            <code>null</code>.
   * @return an array of parameterizations; may be <code>null</code>.
   * @throws SerializationException
   *             if there is an error deserializing the parameters
   * @since 3.2
   */
  std::vector<Parameterization> GetParameterizations(
      const std::string& serializedParameters,
      const std::vector<SmartPointer<IParameter> >& parameters) const
      throw(SerializationException);

  /**
   * Searches for the index of a <code>char</code> in a <code>String</code>
   * but disregards characters prefixed with the {@link #ESCAPE_CHAR} escape
   * character. This is used by {@link #deserialize(String)} and
   * {@link #getParameterizations(String, IParameter[])} to parse the
   * serialized parameterized command string.
   *
   * @param escapedText
   *            the string to search for the index of <code>ch</code> in
   * @param ch
   *            a character to search for in <code>escapedText</code>
   * @return the index of the first unescaped occurrence of the character in
   *         <code>escapedText</code>, or <code>-1</code> if the
   *         character does not occur unescaped.
   * @see String#indexOf(int)
   */
  std::string::size_type UnescapedIndexOf(const std::string& escapedText, const char ch) const;

};

}

#endif /* BERRYCOMMANDMANAGER_H_ */
