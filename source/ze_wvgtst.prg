/*
ZE_WVGTST - GTWVG Controls baseado nos fontes da GTWVG
2016.03 José Quintas

Note: Style = xxS_*   Message = xxM_*

2018.04.02 - Ajuste em HB_GTE_COMMAND referente foco em CRT
*/

#require "gtwvg.hbc"

#include "hbclass.ch"
#include "inkey.ch"
#include "hbgtinfo.ch"
#include "hbgtwvg.ch"
#include "wvtwin.ch"
#include "wvgparts.ch"

*/

/* Harbour 3.2 */

//#define WIN_MAKELONG( lw, hw )     hb_bitOr( hb_bitShift( hb_bitAnd( hw, 0xFFFF ), 16 ), hb_bitAnd( lw, 0xFFFF ) )

//#define WIN_WS_EX_CLIENTEDGE       WS_EX_CLIENTEDGE
//#define WIN_WS_EX_TRANSPARENT      WS_EX_TRANSPARENT

//#define WIN_WM_GETFONT             WM_GETFONT
//#define WIN_WM_SETFONT             WM_SETFONT
//#define WIN_WM_SIZE                WM_SIZE
//#define WIN_WM_LBUTTONUP           WM_LBUTTONUP
//#define WIN_WM_SETTEXT             WM_SETTEXT
//#define WIN_WM_USER                WM_USER

//#define EVENT_HANDLED              1
//#define EVENT_UNHANDLED            0

/* progressbar already on Harbour 3.4 */

//#define PBS_MARQUEE                8

//#define PBM_SETMARQUEE             ( WM_USER + 10 )

/* listview */

#define LVS_EX_FULLROWSELECT         0x00000020 // applies to report mode only

#define LVM_SETEXTENDEDLISTVIEWSTYLE ( LVM_FIRST + 54 )
#define LVM_INSERTCOLUMNA            ( LVM_FIRST + 27 )
#define LVM_INSERTCOLUMNW            ( LVM_FIRST + 97 )
#ifdef UNICODE
#define  LVM_INSERTCOLUMN         LVM_INSERTCOLUMNW
#define  LVM_INSERTITEM           LVM_INSERTITEMW
#else
#define  LVM_INSERTCOLUMN         LVM_INSERTCOLUMNA
#define  LVM_INSERTITEM           LVM_INSERTITEMA
#endif
#define LVM_INSERTITEMA              ( LVM_FIRST + 7 )
#define LVM_INSERTITEMW              ( LVM_FIRST + 77 )

/* button command link */

#define BS_COMMANDLINK               0x0000000E
#define BCM_FIRST                    0x1600
#define BCM_SETNOTE                  ( BCM_FIRST + 9 )

/* trackbar */

#define TBS_AUTOTICKS           0x0001
#define TBS_VERT                0x0002
#define TBS_HORZ                0x0000
#define TBS_TOP                 0x0004
#define TBS_BOTTOM              0x0000
#define TBS_LEFT                0x0004
#define TBS_RIGHT               0x0000
#define TBS_BOTH                0x0008
#define TBS_NOTICKS             0x0010
#define TBS_ENABLESELRANGE      0x0020
#define TBS_FIXEDLENGTH         0x0040
#define TBS_NOTHUMB             0x0080
#define TBM_GETPOS                   ( WIN_WM_USER )
#define TBM_SETTIC                   ( WIN_WM_USER + 4 )
#define TBM_SETPOS                   ( WIN_WM_USER + 5 )
#define TBM_SETRANGE                 ( WIN_WM_USER + 6 )
#define TBM_SETSEL                   ( WIN_WM_USER + 10 )
#define TBM_SETPAGESIZE              ( WIN_WM_USER + 21 )

/* updown */

#define UDS_ALIGNRIGHT               0x0004
#define UDM_SETRANGE                 ( WIN_WM_USER + 101 )
#define UDM_SETPOS                   ( WIN_WM_USER + 103 )

//CREATE CLASS wvgTstAnimation INHERIT wvgtstControl
//ENDCLASS

CREATE CLASS wvgTstBitmap INHERIT wvgtstControl

   VAR ClassName   INIT "STATIC"
   VAR ObjType     INIT objTypeStatic
   VAR Style       INIT WIN_WS_CHILD + WIN_WS_GROUP + SS_BITMAP + SS_CENTERIMAGE + WIN_WS_EX_TRANSPARENT
   VAR nIconBitmap INIT WIN_IMAGE_BITMAP

   ENDCLASS

CREATE CLASS wvgTstButton INHERIT wvgtstControl

   VAR className INIT "BUTTON"
   VAR objType   INIT objTypePushButton
   VAR style     INIT WIN_WS_CHILD + BS_PUSHBUTTON + BS_NOTIFY + BS_FLAT

   ENDCLASS

CREATE CLASS wvgTstCheckBox INHERIT wvgtstControl

   VAR ClassName INIT "BUTTON"
   VAR objType   INIT objTypeCheckBox
   VAR Style     INIT WIN_WS_CHILD + BS_AUTOCHECKBOX // WIN_WS_TABSTOP + BS_LEFTTEXT
   METHOD SetCheck( lCheck ) INLINE ::SendMessage( BM_SETCHECK, iif( lCheck, BST_CHECKED, BST_UNCHECKED ), 0 )

   ENDCLASS

CREATE CLASS wvgTstCombobox INHERIT wvgtstControl

   VAR ClassName             INIT   "COMBOBOX"
   VAR ObjType               INIT   objTypeComboBox
   VAR Style                 INIT   WIN_WS_CHILD + WIN_WS_BORDER + WIN_WS_GROUP + CBS_DROPDOWNLIST // WIN_WS_TABSTOP +
   METHOD AddItem( cText )   INLINE ::SendMessage( CB_ADDSTRING, 0, cText )
   METHOD SetValue( nIndex ) INLINE ::SendMessage( CB_SETCURSEL, nIndex - 1, 0 )
   METHOD Clear()            INLINE ::SendMessage( CB_RESETCONTENT, 0, 0 )

   ENDCLASS

CREATE CLASS wvgTstCommandLink INHERIT wvgtstControl

   VAR ClassName           INIT   "BUTTON"
   VAR objType             INIT   objTypePushButton
   VAR Style               INIT   WIN_WS_CHILD + WIN_WS_BORDER + WIN_WS_GROUP + BS_COMMANDLINK // WIN_WS_TABSTOP +
   METHOD SetNote( cText ) INLINE ::SendMessage( BCM_SETNOTE, 0, cText )

   ENDCLASS

   //CREATE CLASS wvgTstDateTimePicker INHERIT wvgtstControl
   //ENDCLASS

CREATE CLASS wvgTstEdit INHERIT wvgtstControl

   VAR ClassName  INIT "EDIT"
   VAR objType    INIT objTypeSLE
   VAR Style      INIT WIN_WS_CHILD + WIN_WS_TABSTOP + WIN_WS_BORDER

   ENDCLASS

CREATE CLASS wvgTstEditMultiline INHERIT wvgtstControl

   VAR ClassName INIT "EDIT"
   VAR ObjType   INIT objTypeMLE
   VAR Style     INIT WIN_WS_CHILD + WIN_WS_TABSTOP + ES_AUTOVSCROLL + ES_MULTILINE + ;
      ES_WANTRETURN + WIN_WS_BORDER + WIN_WS_VSCROLL

   ENDCLASS

   //CREATE CLASS wvgTstFlatScrollbar INHERIT wvgtstControl
   //ENDCLASS

CREATE CLASS wvgTstFrame INHERIT wvgtstControl

   VAR ClassName  INIT "STATIC"
   VAR objType    INIT objTypeStatic
   VAR Style     INIT WIN_WS_CHILD + WIN_WS_GROUP + BS_GROUPBOX

   ENDCLASS

CREATE CLASS wvgTstGroupbox INHERIT wvgtstControl

   VAR className INIT "BUTTON"
   VAR objType   INIT objTypePushButton
   VAR style     INIT WIN_WS_CHILD + WIN_WS_VISIBLE + BS_GROUPBOX + WIN_WS_EX_TRANSPARENT // WIN_WS_TABSTOP +

   ENDCLASS

   //CREATE CLASS wvgTstHeader INHERIT wvgtstControl
   //VAR ClassName INIT "SysHeader32"
   //VAR Style     INIT WS_CHILD + WS_BORDER + HDS_BUTTONS + HDS_HORZ
   //ENDCLASS

   //CREATE CLASS wvgTstHotkey INHERIT wvgtstControl
   //ENDCLASS

   //CREATE CLASS wvgTstHyperlink INHERIT wvgtstControl
   //VAR ClassName  INIT "WC_LINK"
   //VAR objType    INIT objTypePushButton // *
   //ENDCLASS

CREATE CLASS wvgTstIcon INHERIT wvgtstControl

   VAR ClassName   INIT "STATIC"
   VAR objType     INIT objTypeStatic
   VAR Style       INIT WIN_WS_CHILD + WIN_WS_GROUP + WIN_WS_EX_TRANSPARENT + SS_ICON + SS_CENTERIMAGE
   VAR nIconBitmap INIT WIN_IMAGE_ICON

   ENDCLASS

   //CREATE CLASS wvgTstImage INHERIT wvgtstControl
   //VAR className INIT "STATIC"
   //VAR objType   INIT objTypeStatic
   //VAR style     INIT WIN_WS_CHILD
   //ENDCLASS

   //CREATE CLASS wvgTstImageList INHERIT wvgtstControl
   //ENDCLASS

   //CREATE CLASS wvgTstIpAdress
   //ENDCLASS

CREATE CLASS wvgTstLineHorizontal INHERIT wvgtstControl

   VAR ClassName  INIT "STATIC"
   VAR objType    INIT objTypeStatic
   VAR Style      INIT WIN_WS_CHILD + WIN_WS_VISIBLE + SS_ETCHEDHORZ + SS_SUNKEN

   ENDCLASS

CREATE CLASS wvgTstLineVertical INHERIT wvgtstControl

   VAR ClassName  INIT "STATIC"
   VAR objType    INIT objTypeStatic
   VAR Style      INIT WIN_WS_CHILD + WIN_WS_VISIBLE + SS_ETCHEDVERT + SS_SUNKEN

   ENDCLASS

CREATE CLASS wvgTstListbox INHERIT wvgtstControl

   VAR ClassName           INIT   "LISTBOX"
   VAR objType             INIT   objTypeListBox
   VAR Style               INIT   WIN_WS_CHILD + WIN_WS_VISIBLE + WIN_WS_TABSTOP + WIN_WS_GROUP
   METHOD AddItem( cText ) INLINE ::SendMessage( LB_ADDSTRING, 0, cText )
   METHOD Clear()          INLINE ::SendMessage( LB_RESETCONTENT, 0, 0 )
   METHOD ListCount()      INLINE ::SendMessage( LB_GETCOUNT, 0, 0 )
   METHOD ListItem()       INLINE ::SendMessage( LB_GETCURSEL, 0, 0 ) + 1

   ENDCLASS

CREATE CLASS wvgTstListView INHERIT wvgtstControl

   VAR ClassName          INIT "SysListView32"
   VAR objType            INIT objTypeListBox // quebra-galho
   VAR Style              INIT WS_CHILD + WIN_WS_VISIBLE

   ENDCLASS
   //oControl:SendMessage( LVM_SETEXTENDEDLISTVIEWSTYLE, 0, LVS_EX_FULLROWSELECT )
   //oControl:SendMessage( LVM_INSERTCOLUMN, 0, "Sub item1" )
   //oControl:SendMessage( LVM_INSERTCOLUMN, 1, "Sub item2" )
   //oControl:SendMessage( LVM_INSERTCOLUMN, 2, "Sub item3" )
   //oControl:SendMessage( LVM_INSERTCOLUMN, 3, "Sub item4" )
   //oControl:SendMessage( LVM_INSERTCOLUMN, 4, "Sub item5" )
   //FOR nCont = 1 TO 10
   //   oControl:SendMessage( LVM_INSERTITEM, 0, 0 )
   //   FOR nCont2 = 1 TO 5
   //      oControl:SendMessage( LVM_INSERTCOLUMN, 0, { LVIF_TEXT, 256, 0, 0, "text" } )
   //   NEXT
   //NEXT

   //CREATE CLASS wvgTstMaskEdit INHERIT wvgtstControl
   //ENDCLASS

CREATE CLASS wvgTstMonthCalendar INHERIT wvgtstControl

   VAR ClassName INIT "SysMonthCal32"
   VAR objType   INIT objTypeStatic
   VAR Style     INIT WIN_WS_CHILD // + MCS_NOTODAY + MCS_NOTODAYCIRCLE + MCS_WEEKNUMBERS
   METHOD create( oParent, oOwner, aPos, aSize, aPresParams, lVisible )

   ENDCLASS

METHOD create( oParent, oOwner, aPos, aSize, aPresParams, lVisible )

   aSize := { 170, 245 }
   ::wvgtstControl:Create( oParent, oOwner, aPos, aSize, aPresParams, lVisible )

   RETURN SELF

   //CREATE CLASS wvgTstPager INHERIT wvgtstControl
   //ENDCLASS

   //CREATE CLASS wvgTstPathEdit INHERIT wvgtstControl
   //ENDCLASS

   //CREATE CLASS wvgTstRichEdit INHERIT wvgtstControl
   //ENDCLASS

CREATE CLASS wvgTstRadioButton INHERIT wvgtstControl

   VAR ClassName INIT "BUTTON"
   VAR ObjType   INIT objTypePushButton
   VAR Style     INIT WIN_WS_CHILD + BS_AUTORADIOBUTTON // WIN_WS_TABSTOP +
   // BS_LEFTTEXT
   METHOD SetCheck( lCheck ) INLINE ::SendMessage( BM_SETCHECK, iif( lCheck, BST_CHECKED, BST_UNCHECKED ), 0 )

   ENDCLASS

   //CREATE CLASS wvgTstRebar INHERIT wvgtstControl
   //VAR ClassName INIT "reBarWindow32"
   //ENDCLASS

CREATE CLASS wvgTstRectangle INHERIT wvgtstControl

   VAR ClassName INIT "STATIC"
   VAR ObjType   INIT objTypeStatic
   VAR Style     INIT WIN_WS_CHILD + WIN_WS_GROUP

   ENDCLASS

CREATE CLASS wvgTstScrollbar INHERIT wvgtstControl

   VAR ClassName INIT "SCROLLBAR"
   VAR Style     INIT WIN_WS_CHILD
   // SBS_VERT SBS_HORZ

   ENDCLASS

CREATE CLASS wvgTstscrollText INHERIT wvgtstControl

   VAR ClassName INIT "EDIT"
   VAR Style     INIT WIN_WS_CHILD + ES_AUTOHSCROLL + WIN_WS_GROUP // WIN_WS_TABSTOP +

   ENDCLASS

CREATE CLASS wvgTstStatusbar INHERIT wvgtstControl

   VAR ClassName INIT "msctls_statusbar32"
   VAR Style  INIT WIN_WS_CHILD + WIN_WS_BORDER

   ENDCLASS

   //CREATE CLASS wvgTstTab INHERIT wvgtstControl
   //ENDCLASS

   //CREATE CLASS wvgTstTabCtl32 INHERIT vgtstControl
   //VAR ClassName INIT "SysTabControl32"
   //VAR Style     INIT WIN_WS_CHILD + TCS_FOCUSNEVER
   //VAR objType   INIT objTypeTabPage
   //ENDCLASS

   //CREATE CLASS wvgTstTaskDialog INHERIT wvgtstControl
   //ENDCLASS

CREATE CLASS wvgTstText INHERIT wvgtstControl

   VAR ClassName INIT "STATIC"
   VAR objType   INIT objTypeStatic
   VAR Style     INIT WIN_WS_CHILD + WIN_WS_GROUP + WIN_WS_EX_TRANSPARENT + SS_LEFT + SS_SIMPLE // + SS_LABEL
   METHOD new( oParent, oOwner, aPos, aSize, aPresParams, lVisible )

   ENDCLASS

METHOD new( oParent, oOwner, aPos, aSize, aPresParams, lVisible )

   ::Clr_FG := hb_ColorIndex( SetColor(), 0 )
   ::clr_BG := hb_ColorIndex( SetColor(), 0 )
   ::wvgtstControl:new( oParent, oOwner, aPos, aSize, aPresParams, lVisible )

   RETURN SELF

   //CREATE CLASS wvgTstToolbar INHERIT wvgtstControl
   //VAR ClassName INIT "ToolbarWindow32"
   //ENDCLASS

   //CREATE CLASS wvgTstTooltip INHERIT wvgtstControl
   //ENDCLASS

CREATE CLASS wvgtstTrackbar INHERIT wvgtstControl

   VAR ClassName INIT "msctls_trackbar32"
   VAR Style     INIT WS_CHILD + WS_VISIBLE + TBS_ENABLESELRANGE + TBS_AUTOTICKS
   VAR nValue    INIT 0
   VAR bChanged  INIT NIL
   METHOD SetValues( nValue, nRangeMin, nRangeMax )
   METHOD handleEvent( nMessage, aNM )

   ENDCLASS

METHOD wvgtstTrackbar:SetValues( nValue, nRangeMin, nRangeMax )

   IF HB_ISNUMERIC( nRangeMin ) .AND. HB_ISNUMERIC( nRangeMax )
      ::SendMessage( TBM_SETRANGE, .T., WIN_MAKELONG( nRangeMin, nRangeMax ) )
      ::SendMessage( TBM_SETSEL, .F., WIN_MAKELONG( nRangeMin, nRangeMax ) )
   ENDIF
   IF HB_ISNUMERIC( nValue )
      ::SendMessage( TBM_SETPOS, .T., nValue )
      ::nValue := nValue
   ENDIF

   RETURN NIL

METHOD wvgtstTrackbar:handleEvent( nMessage, aNM )

   WriteLogWndProc( nMessage, "tstControl " + ::ClassName, ::nControlID )

   IF nMessage == WM_CLOSE                           // Works ok, but WM_CLOSE ????
      ::nValue := ::SendMessage( TBM_GETPOS, 0, 0 )
      IF ::bChanged != NIL
         Eval( ::bChanged, ::nValue )
      ENDIF
   ENDIF

   RETURN ::wvgtstControl:HandleEvent( nMessage, aNM )

   //CREATE CLASS wvgTstTreeview INHERIT wvgtstControl
   //ENDCLASS

CREATE CLASS wvgTstUpDown INHERIT wvgtstControl

   VAR ClassName INIT "msctls_updown32"
   VAR Style     INIT WS_CHILD + WS_VISIBLE + UDS_ALIGNRIGHT
   METHOD SetValues( nValue, nRangeMin, nRangeMax )

   ENDCLASS

METHOD wvgTstUpDown:SetValues( nValue, nRangeMin, nRangeMax )

   IF HB_ISNUMERIC( nRangeMin ) .AND. HB_ISNUMERIC( nRangeMax )
      ::SendMessage( UDM_SETRANGE, 0, WIN_MAKELONG( nRangeMin, nRangeMax ) )
   ENDIF
   IF HB_ISNUMERIC( nValue )
      ::SendMessage( UDM_SETPOS, 0, nValue )
   ENDIF

   RETURN NIL

STATIC FUNCTION WriteLogWndProc( nEvent, cWhere, nControlID )

   LOCAL xEvent := "Unknown", xLogFile := "HB_OUT.LOG", xText, nHandle

   nControlId := iif( HB_ISNUMERIC( nControlId ), nControlId, -1 )

   DO CASE
   CASE .T.                            ; RETURN NIL // remove when need debug
   CASE nEvent == 0 /* WM_NULL */      ; /*   0 */ xEvent := "WM_NULL"
   CASE nEvent == WIN_WM_CREATE        ; /*   1 */ xEvent := "WM_CREATE"
   CASE nEvent == WIN_WM_DESTROY       ; /*   2 */ xEvent := "WM_DESTROY"
   CASE nEvent == WIN_WM_MOVE          ; /*   3 */ xEvent := "WM_MOVE "
   CASE nEvent == WIN_WM_SIZE          ; /*   5 */ xEvent := "WM_SIZE"
   CASE nEVent == WIN_WM_ACTIVATE      ; /*   6 */ xEvent := "WM_ACTIVATE"
   CASE nEvent == WIN_WM_SETFOCUS      ; /*   7 */ xEvent := "WM_SETFOCUS"
   CASE nEvent == WIN_WM_KILLFOCUS     ; /*   8 */ xEvent := "WM_KILLFOCUS"
   CASE nEvent == WIN_WM_ENABLE        ; /*  10 */ RETURN NIL // xEvent := "WM_ENABLE"
   CASE nEvent == WIN_WM_SETREDRAW     ; /*  11 */ xEvent := "WM_SETREDRAW"
   CASE nEvent == WIN_WM_SETTEXT       ; /*  12 */ RETURN NIL // xEvent := "WM_SETTEXT"
   CASE nEVent == WIN_WM_GETTEXT       ; /*  13 */ xEvent := "WM_GETTEXT"
   CASE nEvent == WIN_WM_GETTEXTLENGTH ; /*  14 */ xEvent := "WM_GETTEXTLENGTH"
   CASE nEvent == WIN_WM_PAINT         ; /*  15 */ xEvent := "WM_PAINT"
   CASE nEvent == WIN_WM_CLOSE         ; /*  16 */ xEvent := "WM_CLOSE"       // On Trackbar means value changed
   CASE nEvent == WIN_WM_ERASEBKGND    ; /*  20 */ xEvent := "WM_ERASEBKGND"
   CASE nEvent == 25 /* WM_CTLCOLOR */ ; /*  25 */ xEvent := "WM_CTLCOLOR"
   CASE nEvent == WIN_WM_SETFONT       ; /*  48 */ xEvent := "WM_SETFONT"
   CASE nEvent == WIN_WM_GETFONT       ; /*  49 */ xEvent := "WM_GETFONT"
   CASE nEvent == WIN_WM_NOTIFY        ; /*  78 */ xEvent := "WM_NOTIFY"
   CASE nEvent == WIN_WM_GETICON       ; /* 127 */ xEvent := "WM_GETICON"
   CASE nEvent == WIN_WM_SETICON       ; /* 128 */ xEvent := "WM_SETICON"
   CASE nEvent == WIN_WM_COMMAND       ; /* 273 */ xEvent := "WM_COMMAND"
   OTHERWISE
   ENDCASE
   xText := Time() + " " + cWhere + " " + Str( nControlId, 6 ) + " " + Str( nEvent, 6 ) + " " + xEvent
   IF ! File( xLogFile )
      nHandle := fCreate( xLogFile )
      fClose( nHandle )
   ENDIF
   nHandle := fOpen( xLogFile, 1 )
   fSeek( nHandle, 0, 2 )
   fWrite( nHandle, xText + HB_EOL() )
   fClose( nHandle )

   RETURN NIL

CREATE CLASS wvgtstControl INHERIT WvgWindow

   VAR    autosize                              INIT .F.
   VAR    Border                                INIT .T.
   VAR    cancel                                INIT .F.
   VAR    cText
   VAR    default                               INIT .F.
   VAR    drawMode                              INIT WVG_DRAW_NORMAL
   VAR    preSelect                             INIT .F.
   VAR    pointerFocus                          INIT .F.
   VAR    Style                                 INIT 0
   VAR    cImage
   VAR    nIconBitmap                           INIT 0
   VAR    lSetCallback                          INIT .T.
   VAR    cFontName
   VAR    nFontSize
   VAR    lImageResize                          INIT .T.

   METHOD new( oParent, oOwner, aPos, aSize, aPresParams, lVisible )
   METHOD create( oParent, oOwner, aPos, aSize, aPresParams, lVisible )
   METHOD configure( oParent, oOwner, aPos, aSize, aPresParams, lVisible )
   METHOD destroy()
   METHOD handleEvent( nMessage, aNM )

   METHOD activate( xParam )                    SETGET
   METHOD setText()
   METHOD SetImage()
   METHOD draw( xParam )                        SETGET

   ENDCLASS

METHOD wvgtstControl:new( oParent, oOwner, aPos, aSize, aPresParams, lVisible )

   ::wvgWindow:new( oParent, oOwner, aPos, aSize, aPresParams, lVisible )

   RETURN Self

METHOD wvgtstControl:create( oParent, oOwner, aPos, aSize, aPresParams, lVisible )

   LOCAL hOldFont

   //DO CASE
   //CASE ::nIconBitmap == 1 ; ::style += BS_ICON
   //CASE ::nIconBitmap == 2 ; ::style += BS_BITMAP
   //ENDCASE

   ::wvgWindow:create( oParent, oOwner, aPos, aSize, aPresParams, lVisible )

   ::oParent:AddChild( Self )

   ::createControl()
   IF ::lSetCallback
      ::SetWindowProcCallback()  /* Let parent take control of it */
   ENDIF

   IF ::cFontName != NIL
      hOldFont := ::SendMessage( WIN_WM_GETFONT )
      ::SendMessage( WIN_WM_SETFONT, wvt_CreateFont( ::cFontName, ::nFontSize ), 0 )
      wvg_DeleteObject( hOldFont )
   ENDIF
   ::SetImage()
   ::SetText()
   IF ! Empty( ::clr_BG )
      ::SetColorBG( ::Clr_BG )
   ENDIF
   IF ! Empty( ::Clr_FG )
      ::SetColorFG( ::Clr_FG )
   ENDIF
   //IF ::IsCrtParent()
   //hOldFont := ::oParent:SendMessage( WIN_WM_GETFONT )
   //::SendMessage( WIN_WM_SETFONT, hOldFont, 0 )
   //ENDIF
   IF ::visible
      ::show()
   ENDIF
   ::setPosAndSize()

   RETURN SELF

METHOD wvgtstControl:handleEvent( nMessage, aNM )

   WriteLogWndProc( nMessage, "tstControl " + ::ClassName, ::nControlID )
   DO CASE
   CASE nMessage == HB_GTE_RESIZED
      IF ::isParentCrt()
         ::rePosition()
      ENDIF
      IF ::ClassName == "SysMonthCal32"
         ::InvalidateRect()
      ELSE
         ::sendMessage( WIN_WM_SIZE, 0, 0 )
         IF HB_ISEVALITEM( ::sl_resize )
            Eval( ::sl_resize, , , Self )
         ENDIF
      ENDIF
      IF ::ClassName != "BUTTON"
         ::SetImage()
      ENDIF

      RETURN EVENT_HANDLED

   CASE nMessage == HB_GTE_COMMAND
      IF aNM[ 1 ] == BN_CLICKED
         IF ::isParentCrt()
            ::oParent:setFocus()
         ENDIF
         IF HB_ISEVALITEM( ::sl_lbClick )
            Eval( ::sl_lbClick, , , SELF )
            IF ::pointerFocus
               ::setFocus()
            ENDIF
         ENDIF
         RETURN EVENT_HANDLED
      ENDIF
      IF ::isParentCrt() .AND. ! ::PointerFocus
         ::oParent:setFocus()
      ENDIF

   CASE nMessage == HB_GTE_NOTIFY

   CASE nMessage == HB_GTE_CTLCOLOR
      // error on harbour 3.2
      IF HB_ISNUMERIC( ::clr_FG )
         wapi_SetTextColor( aNM[ 1 ], ::clr_FG )
      ENDIF
      IF ! Empty( ::hBrushBG )
         wapi_SetBkMode( aNM[ 1 ], WIN_TRANSPARENT )
         RETURN ::hBrushBG
      ENDIF

   CASE ::lSetCallback .AND. nMessage == HB_GTE_ANY
      IF aNM[ 1 ] == WIN_WM_LBUTTONUP
         IF HB_ISEVALITEM( ::sl_lbClick )
            IF ::isParentCrt()
               ::oParent:setFocus()
            ENDIF
            Eval( ::sl_lbClick, , , SELF )
         ENDIF
      ENDIF
   OTHERWISE
      RETURN ::wvgwindow:handleEvent( nMessage, aNM )
   ENDCASE

   RETURN EVENT_UNHANDLED

METHOD PROCEDURE wvgtstControl:destroy()

   LOCAL hOldFont, hOldImage

   hOldImage := ::SendMessage( STM_SETIMAGE, ::nIconBitmap, NIL )
   IF hOldImage != NIL
      wvg_DeleteObject( hOldImage )
   ENDIF
   IF ::cFontName != NIL
      hOldFont := ::SendMessage( WIN_WM_GETFONT )
      ::wvgWindow:destroy()
      ::wvgWindow:destroy()
      wvg_DeleteObject( hOldFont )
   ENDIF
   ::wvgWindow:Destroy()
   RETURN

METHOD wvgtstControl:configure( oParent, oOwner, aPos, aSize, aPresParams, lVisible )

   ::Initialize( oParent, oOwner, aPos, aSize, aPresParams, lVisible )

   RETURN SELF

METHOD wvgtstControl:SetText()

   IF HB_ISCHAR( ::cText )
      ::SendMessage( WIN_WM_SETTEXT, 0, ::cText )
   ENDIF

   RETURN NIL

METHOD wvgtstControl:SetImage()

   LOCAL nWidth, nHeight, hOldImage

   IF ::cImage != NIL .AND. ( ::nIconBitmap == WIN_IMAGE_ICON .OR. ::nIconBitmap == WIN_IMAGE_BITMAP )
      IF ::lImageResize
         nWidth  := ::CurrentSize()[ 1 ]
         nHeight := ::CurrentSize()[ 2 ]
      ENDIF
      // BM_SETIMAGE on button, STM_SETIMAGE on others, limited to resource by name
      hOldImage := ::SendMessage( STM_SETIMAGE, ::nIconBitmap, wapi_LoadImage( wapi_GetModuleHandle(), ::cImage, ::nIconBitmap, nWidth, nHeight, WIN_LR_DEFAULTSIZE ) )
      IF hOldImage != NIL
         wvg_DeleteObject( hOldImage )
      ENDIF
   ENDIF

   RETURN NIL

METHOD wvgtstControl:draw( xParam )

   IF HB_ISEVALITEM( xParam ) .OR. xParam == NIL
      ::sl_paint := xParam
   ENDIF

   RETURN SELF

METHOD wvgtstControl:activate( xParam )

   IF HB_ISEVALITEM( xParam ) .OR. xParam == NIL
      ::sl_lbClick := xParam
   ENDIF

   RETURN SELF
