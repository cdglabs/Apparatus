R = require "./R"
Model = require "../Model/Model"


R.create "Editor",
  propTypes:
    editor: Model.Editor

  childContextTypes:
    editor: Model.Editor
    project: Model.Project

  getChildContext: ->
    {editor} = @props
    {
      editor: editor
      project: editor.project
    }

  render: ->
    R.MouseManagersWrapper {},
      R.div { className: "Editor" },
        R.DragHint {}
        R.CreatePanel {}
        R.div { className: "Center" },
          R.Menubar {}
          R.EditorCanvas {}
        R.RightPanel {}


# This wrapper provides a DragManager and HoverManager for its children to
# share. It also sets a global cursor if the current drag wants one.
R.create "MouseManagersWrapper",
  childContextTypes:
    dragManager: R.DragManager
    hoverManager: R.HoverManager

  getChildContext: ->
    dragManager: @_dragManager
    hoverManager: @_hoverManager

  componentWillMount: ->
    @_dragManager = new R.DragManager()
    @_hoverManager = new R.HoverManager()

  render: ->
    {className, children} = @props
    cursor = @_dragManager.drag?.cursor

    R.div {
      className: R.cx
        MouseManagersWrapper: true
        CursorOverride: cursor?
      style:
        cursor: cursor ? ""
    },
      children


# This wrapper is used in Expression where we need to be able to render
# ReactElements within a CodeMirror mark. It may not be needed in the future
# if React migrates from context coming from owner to context coming from
# parent. See: https://gist.github.com/jimfb/0eb6e61f300a8c1b2ce7
R.create "ContextWrapper",
  propTypes:
    childRender: Function
    context: Object

  childContextTypes:
    editor: Model.Editor
    project: Model.Project
    dragManager: R.DragManager
    hoverManager: R.HoverManager

  getChildContext: ->
    @props.context

  render: -> @props.childRender()


R.create "DragHint",
  contextTypes:
    dragManager: R.DragManager

  render: ->
    {dragManager} = @context

    drag = dragManager.drag

    R.div {className: "DragHintContainer"},
      if drag?.type == "transcludeAttribute" and drag.consummated
        R.div {
          className: "DragHint"
          style:
            left: drag.x + 5
            top:  drag.y + 5
        },
          R.AttributeToken {attribute: drag.attribute, contextElement: null}
