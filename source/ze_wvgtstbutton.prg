/*
ZE_WVGBUTTON - Pushbutton pra wWVG baseado no fonte original da WVG
Alterado por José Quintas

2018.03.08 Resize image mesmo abaixo de 32 pixels
*/

// INCOMPATIBLE INCOMPLETE INCOMPATIBLE INCOMPLETE INCOMPATIBLE INCOMPLETE INCOMPATIBLE INCOMPLETE

#require "gtwvg.hbc"

#include "hbclass.ch"
#include "inkey.ch"
#include "hbgtinfo.ch"
#include "wvgparts.ch"
#include "wvtwin.ch"
#include "hbgtwvg.ch"

//#include "hbgtwvg.ch"
//#include "wvtwin.ch"
//#include "wvgparts.ch"

CREATE CLASS wvgtstPushbutton INHERIT WvgWindow

   VAR    ClassName       INIT "BUTTON"
   VAR    autosize        INIT .F.
   VAR    border          INIT .T.
   VAR    caption
   VAR    pointerFocus    INIT .F.
   VAR    preSelect       INIT .F.
   VAR    drawMode        INIT WVG_DRAW_NORMAL
   VAR    default         INIT .F.
   VAR    cancel          INIT .F.
   VAR    oImage
   VAR    lImageResize    INIT .F.
   VAR    nImageAlignment INIT 0

   METHOD new( oParent, oOwner, aPos, aSize, aPresParams, lVisible )
   METHOD create( oParent, oOwner, aPos, aSize, aPresParams, lVisible )
   METHOD configure( oParent, oOwner, aPos, aSize, aPresParams, lVisible )
   METHOD destroy()
   METHOD handleEvent( nMessage, aNM )

   METHOD Repaint()
   METHOD setCaption( xCaption, cDll )
   METHOD activate( xParam )                    SETGET
   METHOD draw( xParam )                        SETGET

   //METHOD setColorFG()                          INLINE NIL
   //METHOD setColorBG()                          INLINE NIL

   ENDCLASS

METHOD wvgtstPushbutton:new( oParent, oOwner, aPos, aSize, aPresParams, lVisible )

   ::wvgWindow:new( oParent, oOwner, aPos, aSize, aPresParams, lVisible )

   ::style       := WIN_WS_CHILD + BS_PUSHBUTTON + BS_NOTIFY + BS_FLAT /* + BS_PUSHLIKE */
   ::className   := "BUTTON"
   ::objType     := objTypePushButton

   RETURN Self

   // https://msdn.microsoft.com/en-us/library/windows/desktop/bb761822(v=vs.85).aspx
   // Windows Vista and Upper, can show image + text. Need do not set BS_ICON or BS_BITMAP
   // XP and lower, or image only, need set BS_ICON or BS_BITMAP

METHOD wvgtstPushbutton:create( oParent, oOwner, aPos, aSize, aPresParams, lVisible )

   ::wvgWindow:create( oParent, oOwner, aPos, aSize, aPresParams, lVisible )

   DO CASE
   CASE HB_ISCHAR( ::Caption ) .AND. win_osIsVistaOrUpper()
   CASE HB_ISNUMERIC( ::oImage )
      ::style += BS_BITMAP
   CASE HB_ISCHAR( ::oImage )
      SWITCH Lower( hb_FNameExt( ::caption ) )
      CASE ".ico"
         ::style += BS_ICON
         EXIT
      CASE ".bmp"
         ::style += BS_BITMAP
         EXIT
      ENDSWITCH
   CASE HB_ISARRAY( ::oImage )
      ASize( ::oImage, 3 )
      IF HB_ISNUMERIC( ::oImage[ 2 ] )
         SWITCH ::oImage[ 2 ]
         CASE WVG_IMAGE_ICONFILE
         CASE WVG_IMAGE_ICONRESOURCE
            ::style += BS_ICON
            EXIT
         CASE WVG_IMAGE_BITMAPFILE
         CASE WVG_IMAGE_BITMAPRESOURCE
            ::style += BS_BITMAP
            EXIT
         ENDSWITCH
      ENDIF
   ENDCASE

   IF ! ::border
      ::style += BS_FLAT
   ENDIF
   IF ::nImageAlignment != 0
      ::Style += ::nImageAlignment
   ENDIF

   ::oParent:AddChild( Self )

   ::createControl()
#if 0
   ::SetWindowProcCallback()  /* Let parent take control of it */
#endif

   IF ::visible
      ::show()
   ENDIF
   ::setPosAndSize()

   ::Repaint()

   RETURN Self

METHOD wvgtstPushbutton:handleEvent( nMessage, aNM )

   DO CASE
   CASE nMessage == HB_GTE_RESIZED
      IF ::isParentCrt()
         ::rePosition()
      ENDIF
      ::sendMessage( WIN_WM_SIZE, 0, 0 )
      IF HB_ISEVALITEM( ::sl_resize )
         Eval( ::sl_resize, , , self )
      ENDIF
      ::Repaint()

   CASE nMessage == HB_GTE_COMMAND
      IF aNM[ 1 ] == BN_CLICKED
         IF HB_ISEVALITEM( ::sl_lbClick )
            IF ::isParentCrt()
               ::oParent:setFocus()
            ENDIF
            Eval( ::sl_lbClick, , , self )
            IF ::pointerFocus
               ::setFocus()
            ENDIF
         ENDIF
         RETURN EVENT_HANDLED
      ENDIF

   CASE nMessage == HB_GTE_NOTIFY
      // Will never be issued because pushbutton sends WIN_WM_COMMAND

   CASE nMessage == HB_GTE_CTLCOLOR
      IF HB_ISNUMERIC( ::clr_FG )
         wapi_SetTextColor( aNM[ 1 ], ::clr_FG )
      ENDIF
      IF ! Empty( ::hBrushBG )
         wapi_SetBkMode( aNM[ 1 ], WIN_TRANSPARENT )
         RETURN ::hBrushBG
      ENDIF

#if 0  /* Must not reach here if WndProc is not installed */
   CASE nMessage == HB_GTE_ANY
      IF aNM[ 1 ] == WIN_WM_LBUTTONUP
         IF HB_ISEVALITEM( ::sl_lbClick )
            IF ::isParentCrt()
               ::oParent:setFocus()
            ENDIF
            Eval( ::sl_lbClick, , , Self )
         ENDIF
      ENDIF
#endif
   ENDCASE

   RETURN EVENT_UNHANDLED

METHOD PROCEDURE wvgtstPushbutton:destroy()

   ::wvgWindow:destroy()

   RETURN

METHOD wvgtstPushbutton:configure( oParent, oOwner, aPos, aSize, aPresParams, lVisible )

   ::Initialize( oParent, oOwner, aPos, aSize, aPresParams, lVisible )

   RETURN Self

METHOD wvgtstPushbutton:setCaption( xCaption, cDll )

   HB_SYMBOL_UNUSED( xCaption + cDll )

   RETURN NIL

   // https://msdn.microsoft.com/en-us/library/windows/desktop/ms648045(v=vs.85).aspx
   // Windows Vista and Upper, wapi_LoadImage() can resize image
   // To do: Found a better resize for any combination (text size, image size, border size)

METHOD wvgtstPushbutton:RePaint()

   LOCAL nLoadFromResByIdNumber := 0
   LOCAL nLoadFromResByIdName   := 1
   LOCAL nLoadFromDiskFile      := 2
   LOCAL nWidth, nHeight

   IF ::lImageResize
      nWidth  := ::CurrentSize()[ 1 ] - 3 // 3=border
      nHeight := ::CurrentSize()[ 2 ] - 3 // 3=border
      IF HB_ISCHAR( ::Caption )
         DO CASE
         CASE ::nImageAlignment == BS_TOP   .OR. ::nImageAlignment == BS_BOTTOM
            nHeight -= wvt_GetFontInfo()[ 6 ] - 2
         CASE ::nImageAlignment == BS_RIGHT .OR. ::nImageAlignment == BS_LEFT
            nWidth := nHeight
         ENDCASE
      ENDIF
      //IF nWidth < 32 .OR. nHeight < 32 // do not resize if small area
      //   nWidth  := 0
      //   nHeight := 0
      //ENDIF
   ENDIF

   DO CASE
   CASE HB_ISCHAR( ::oImage )

      SWITCH Lower( hb_FNameExt( ::oImage ) )
      CASE ".ico"
         ::SendMessage( BM_SETIMAGE, WIN_IMAGE_ICON, wvg_LoadImage( ::oImage, nLoadFromDiskFile, WIN_IMAGE_ICON, nWidth, nHeight ) )
         EXIT
      CASE ".bmp"
         ::SendMessage( BM_SETIMAGE, WIN_IMAGE_BITMAP, wvg_LoadImage( ::oImage, nLoadFromDiskFile, WIN_IMAGE_BITMAP, nWidth, nHeight ) )
         EXIT
         //OTHERWISE
         //   ::SendMessage( WIN_WM_SETTEXT, 0, ::caption )
      ENDSWITCH

   CASE HB_ISNUMERIC( ::oImage )  /* Handle to the bitmap */
      ::SendMessage( BM_SETIMAGE, WIN_IMAGE_BITMAP, ::oImage )

   CASE HB_ISARRAY( ::oImage )
      ASize( ::oImage, 4 )
      IF HB_ISCHAR( ::oImage[ 1 ] )
         // ::SendMessage( WIN_WM_SETTEXT, 0, xCaption[ 1 ] )
      ENDIF
      IF ! Empty( ::oImage[ 2 ] )
         SWITCH ::oImage[ 2 ]
         CASE WVG_IMAGE_ICONFILE
            ::SendMessage( BM_SETIMAGE, WIN_IMAGE_ICON, wvg_LoadImage( ::oImage[ 3 ], nLoadFromDiskFile, WIN_IMAGE_ICON, nWidth, nHeight ) )
            EXIT
         CASE WVG_IMAGE_ICONRESOURCE
            IF HB_ISCHAR( ::oImage[ 3 ] )
               ::SendMessage( BM_SETIMAGE, WIN_IMAGE_ICON, wvg_LoadImage( ::oImage[ 3 ], nLoadFromResByIdName, WIN_IMAGE_ICON, nWidth, nHeight ) )
            ELSE
               ::SendMessage( BM_SETIMAGE, WIN_IMAGE_ICON, wvg_LoadImage( ::oImage[ 3 ], nLoadFromResByIdNumber, WIN_IMAGE_ICON, nWidth, nHeight ) )
            ENDIF
            EXIT
         CASE WVG_IMAGE_BITMAPFILE
            ::SendMessage( BM_SETIMAGE, WIN_IMAGE_BITMAP, wvg_LoadImage( ::oImage[ 3 ], nLoadFromDiskFile, WIN_IMAGE_BITMAP, nWidth, nHeight ) )
            EXIT
         CASE WVG_IMAGE_BITMAPRESOURCE
            IF HB_ISCHAR( ::oImage[ 3 ] )
               ::SendMessage( BM_SETIMAGE, WIN_IMAGE_BITMAP, wvg_LoadImage( ::oImage[ 3 ], nLoadFromResByIdName, WIN_IMAGE_BITMAP, nWidth, nHeight ) )
            ELSE
               ::SendMessage( BM_SETIMAGE, WIN_IMAGE_BITMAP, wvg_LoadImage( ::oImage[ 3 ], nLoadFromResByIdNumber, WIN_IMAGE_BITMAP, nWidth, nHeight ) )
            ENDIF
            EXIT
         ENDSWITCH
      ENDIF
   ENDCASE
   IF HB_ISCHAR( ::Caption )
      ::SendMessage( WIN_WM_SETTEXT, 0, ::caption )
   ENDIF

   RETURN Self

METHOD wvgtstPushbutton:activate( xParam )

   IF HB_ISEVALITEM( xParam ) .OR. xParam == NIL
      ::sl_lbClick := xParam
   ENDIF

   RETURN Self

METHOD wvgtstPushbutton:draw( xParam )

   IF HB_ISEVALITEM( xParam ) .OR. xParam == NIL
      ::sl_paint := xParam
   ENDIF

   RETURN Self
