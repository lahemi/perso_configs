--
-- XMonad - Config
--

import XMonad
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Util.Run(spawnPipe)
import XMonad.Util.EZConfig
import Data.Monoid
import System.Exit

import qualified System.IO.UTF8
import qualified XMonad.StackSet as W
import qualified Data.Map        as M

myTerminal      = "termit"
myBorderWidth   = 1
myModMask       = mod4Mask
myWorkspaces    = ["1","2","3","4","5","6","7","8","9"]

myNormalBorderColor  = "#dddddd"
myFocusedBorderColor = "#db2508"

-- Whether focus follows the mouse pointer.
myFocusFollowsMouse :: Bool
myFocusFollowsMouse = False

-- Whether clicking on a window to focus also passes the click to the window
myClickJustFocuses :: Bool
myClickJustFocuses = False

------------------------------------------------------------------------
-- Key bindings. Add, modify or remove key bindings here.
--
myKeys = \c -> mkKeymap c $

    [ ("M-r t",      spawn "termit")
    , ("M-<Return>", spawn "termit")
    , ("M-p",        spawn "dmenu_run")
    , ("M-S-p",      spawn "gmrun")
    , ("M-r s",      spawn "scrot -e 'mv $f ~/Scrots'")
    , ("M-r l",      spawn "luakit")

    , ("M-c", kill)
    , ("M-q", spawn "xmonad --recompile; xmonad --restart")
    , ("M-S-q", io (exitWith ExitSuccess))
    , ("M-S-r", refresh)

    , ("M-<Space>",   sendMessage NextLayout )
    , ("M-S-<Space>", sendMessage FirstLayout)
    , ("M-j",         windows W.focusDown)
    , ("M-k",         windows W.focusUp  )
    , ("M-S-j",       windows W.swapDown )
    , ("M-S-k",       windows W.swapUp   )

    , ("M-+",         spawn "ossmix -q jack.green.front +2")
    , ("M--",         spawn "ossmix -q -- jack.green.front -2")

    -- Move focus to the master window
    , ("M-m",         windows W.focusMaster  )

    -- Shrink/expand the master area
    , ("M-h",         sendMessage Shrink)
    , ("M-l",         sendMessage Expand)

    -- Increment the number of windows in the master area
    , ("M-,",         sendMessage (IncMasterN 1))

    -- Deincrement the number of windows in the master area
    , ("M-.",         sendMessage (IncMasterN (-1)))
    ] ++
    -- mod-[1..9], Switch to workspace N
    -- mod-shift-[1..9], Move client to workspace N
    [(m ++ (show k), windows $ f i)
        | (i, k) <- zip (XMonad.workspaces c) [1 .. 9]
        , (f, m) <- [(W.greedyView, "M-"), (W.shift, "M-S-")]
    ]

------------------------------------------------------------------------
-- Mouse bindings: default actions bound to mouse events
myMouseBindings (XConfig {XMonad.modMask = modMask}) = M.fromList $
    -- mod-button1, Set the window to floating mode and move by dragging
    [ ((modMask, button1), (\w -> focus w >> mouseMoveWindow w))
    -- mod-button2, Raise the window to the top of the stack
    , ((modMask, button2), (\w -> focus w >> windows W.shiftMaster))
    -- mod-button3, Set the window to floating mode and resize by dragging
    , ((modMask, button3), (\w -> focus w >> mouseResizeWindow w))
    ]

------------------------------------------------------------------------
-- Layouts:

-- You can specify and transform your layouts by modifying these values.
-- If you change layout bindings be sure to use 'mod-shift-space' after
-- restarting (with 'mod-q') to reset your layout state to the new
-- defaults, as xmonad preserves your old layout settings by default.
--
-- The available layouts.  Note that each layout is separated by |||,
-- which denotes layout choice.
--
--myLayout = tiled ||| Mirror tiled ||| Full
--  where
--     -- default tiling algorithm partitions the screen into two panes
--     tiled   = Tall nmaster delta ratio
--     -- The default number of windows in the master pane
--     nmaster = 1
--     -- Default proportion of screen occupied by master pane
--     ratio   = 1/2
--     -- Percent of screen to increment by when resizing panes
--     delta   = 3/100

------------------------------------------------------------------------
-- Window rules:
-- To find the property name associated with a program, use
-- > xprop | grep WM_CLASS
-- and click on the client you're interested in.
--
-- To match on the WM_NAME, you can use 'title' in the same way that
-- 'className' and 'resource' are used below.
--
--myManageHook = composeAll
--    [ className =? "MPlayer"        --> doFloat
--    , className =? "Gimp"           --> doFloat
--    , resource  =? "desktop_window" --> doIgnore
--    , resource  =? "kdesktop"       --> doIgnore ]

------------------------------------------------------------------------
-- Event handling
-- * EwmhDesktops users should change this to ewmhDesktopsEventHook
--
-- Defines a custom handler function for X Events. The function should
-- return (All True) if the default handler is to be run afterwards. To
-- combine event hooks use mappend or mconcat from Data.Monoid.
--
myEventHook = mempty

------------------------------------------------------------------------
-- Status bars and logging
-- Perform an arbitrary action on each internal state change or X event.
-- See the 'XMonad.Hooks.DynamicLog' extension for examples.
--
myLogHook = return ()

------------------------------------------------------------------------
-- Startup hook
-- Perform an arbitrary action each time xmonad starts or is restarted
-- with mod-q.  Used by, e.g., XMonad.Layout.PerWorkspace to initialize
-- per-workspace layout choices.
-- By default, do nothing.
myStartupHook = return ()

-----------------------------------------------------------------------
-- Statusbar
-- statusBarCmd= "xmobar ~/.xmonad/xmobarrc
statusBarCmd= "/usr/bin/xmobar /home/blueberry/.xmonad/xmobarrc"
------------------------------------------------------------------------
-- Now run xmonad with all the defaults we set up.

main = do
  xmproc <- spawnPipe statusBarCmd
  xmonad $ defaultConfig {
      manageHook = manageDocks <+> manageHook defaultConfig,
      layoutHook = avoidStruts  $  layoutHook defaultConfig,
      -- simple stuff
      terminal           = myTerminal,
      focusFollowsMouse  = myFocusFollowsMouse,
      clickJustFocuses   = myClickJustFocuses,
      borderWidth        = myBorderWidth,
      modMask            = myModMask,
      workspaces         = myWorkspaces,
      normalBorderColor  = myNormalBorderColor,
      focusedBorderColor = myFocusedBorderColor,

      -- key bindings
      keys               = myKeys,
      mouseBindings      = myMouseBindings,

      -- hooks, layouts
      --layoutHook         = myLayout,
      --manageHook         = myManageHook,
      handleEventHook    = myEventHook,
      logHook            = myLogHook,
      startupHook        = myStartupHook
    }
