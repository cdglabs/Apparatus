R = require "./R"
Model = require "../Model/Model"
Util = require "../Util/Util"


R.create "RightPanel",
  contextTypes:
    editor: Model.Editor
    dragManager: R.DragManager

  _onResizeMouseDown: (mouseDownEvent) ->
    startX = mouseDownEvent.clientX
    layout = @context.editor.layout

    @context.dragManager.start mouseDownEvent,
      cursor: "ew-resize"
      onMove: (moveEvent) =>
        dx = moveEvent.clientX - startX
        startX = moveEvent.clientX
        layout.resizeRightPanel(dx)

  render: ->
    layout = @context.editor.layout

    R.div { 
        className: R.cx {
           RightPanel: true
           FullScreen: layout.fullScreen
        }
        style: {
          width: layout.rightPanelWidth
        }
      },
      R.div { 
        className: "RightResize"
        onMouseDown: @_onResizeMouseDown
      }
      R.div { className: "RightPanelContainer" }, 
        R.Outline {}
        R.Inspector {}
