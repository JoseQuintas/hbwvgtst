/*
TESTGTWVG - Teste das funções adicionais pra GTWVG
José Quintas
*/

#include "inkey.ch"

PROCEDURE Main

   LOCAL oControl, GetList := {}, cText := "This is a GET", nCont

   hb_gtReLoad( "WVG" )
   SetMode( 28, 120 )
   SetColor("N/W,N/W")
   SET SCOREBOARD OFF
   CLS

   SetColor( "B/W" )
   FOR nCont = 1 TO 6
      oControl := wvgtstText():New()
      oControl:cFontName := "Arial"
      oControl:nFontSize := nCont * 10 + 20
      oControl:cText := "Test of " + oControl:cFontName + " " + Ltrim( Str( oControl:nFontSize ) )
      oControl:Create( , , { -( nCont * 4 - 3 ), -95 }, { -4, -20 } )
   NEXT

   oControl := wvgtstMonthCalendar():New()
   oControl:Create( , , { -1, -63 }, { -12, -30 } )

   oControl := wvgtstCommandLink():New()
   oControl:cText := "Cmd Link"
   oControl:Create( , , { -13, -63 }, { -5, -15 } )
   oControl:SetNote( "Vista and Above" )

   oControl := wvgtstTrackbar():New()
   oControl:Create( , , { -20, -60 }, { -2, -20 }, , .F. )
   oControl:SetValues( 1, 1, 20 )
   oControl:Show()

   oCOntrol := wvgtstUpDown():New()
   oControl:Create( , , { -18, -82 }, { -3, -5 } )
   oControl:SetValues( 1, 1, 100 )

   oControl := wvgtstEditMultiline():New()
   oControl:cText := GetEditText()
   oControl:Create( , , { -1, -2 }, { -5, -35 } )

   oControl := wvgtstPushButton():New()
   oControl:oImage := { , WVG_IMAGE_ICONRESOURCE, "tstico" }
   oControl:lImageResize := .T.
   oControl:Create( , , { -7, -2 }, { -9, -30 } )

   oControl := wvgtstLineVertical():New()
   oControl:Create( , , { -1, -38 }, { -16, 4 } )

   oControl := wvgtstScrollbar():New()
   oControl:Style += SBS_VERT
   oControl:Create( , , { -1, -39 }, { -14, -2 } )

   oControl := wvgtstScrollbar():New()
   oControl:Style += SBS_HORZ
   oControl:Create( , , { -17, -2 }, { -1, -36 } )

   oControl := wvgtstLineHorizontal():New()
   oControl:Create( , , { -16.5, -2 }, { 4, -36 } )

   oControl := wvgtstIcon():New()
   oControl:cImage := "tstico"
   oControl:Create( , , { -19, -2 }, { -3, -8 } )

   oControl := wvgtstBitmap():New()
   oControl:cImage := "tstbmp"
   oControl:Create( , , { -19, -41 }, { -3, -8 } )

   oControl := wvgtstcheckbox():New()
   oControl:cText := "Satisfied?"
   oControl:Create( , , { -19, -15 }, { -1, -10 } )

   oControl := wvgtstCheckBox():New()
   oControl:cText := "Not Satisfied?"
   oControl:Style += BS_LEFTTEXT
   oControl:Create( , , { -21, -15 }, { -1, -10 } )

   oControl := wvgtstRectangle():New()
   oControl:Create( , , { -19, -30 }, { -3, -10 } )
   oControl:SetColorBG( WIN_RGB( 52, 101, 164 ) )

   oControl := wvgtstListBox():New()
   oControl:Create( , , { -1, -43 }, { -5, -16 } )
   oControl:AddItem( "Harbour" )
   oControl:AddItem( "GtWvt" )
   oControl:AddItem( "Wvtgui" )
   oControl:AddItem( "Modeless" )
   oControl:AddItem( "Dialogs" )
   oControl:AddItem( "WVT" )

   oControl := wvgtstText():New()
   oControl:cText := "Degree"
   oControl:Create( , , { -6.5, -43 }, { -1, -17 } )

   oControl := wvgtstComboBox():New()
   oControl:Create( , , { -7.5, -43 }, { -6, -17 } )
   oControl:AddItem( "First" )
   oControl:AddItem( "Second" )
   oControl:AddItem( "Third" )
   oControl:AddItem( "Fourth" )
   oControl:AddItem( "Fifth" )
   oControl:SetValue( 1 )

   oControl := wvgtstGroupbox():new()
   oControl:cText := "Compiler"
   oControl:Create( , , { -9, -43 }, { -4.3, -17 } )

   oControl := wvgtstRadioButton():New()
   oControl:cText := "Harbour"
   oControl:Create( , , { -10, -45 }, { -1, -12 } )
   oControl:SetCheck( .T. )

   oControl := wvgtstRadioButton():New()
   oControl:Style += BS_LEFTTEXT
   oControl:cText := "Clipper"
   oControl:Create( , , { -11, -45 }, { -1, -12 } )

   oControl := wvgtstRadioButton():New()
   oControl:cText := "Xbase++"
   oControl:Create( , , { -12, -45 }, { -1, -12 } )

   oControl := wvgtstText():New()
   oControl:cText := "Scrollable Text"
   oControl:Create( , , { -14, -43 }, { -1, -18 } )

   oControl := wvgtstScrollText():New()
   oControl:cText := "This is Text Field"
   oControl:Create( , , { -15, -43 }, { -1, -18 } )

   oControl := wvgtstText():New()
   oControl:cText := "Right Justified Numerics"
   oControl:Create( , , { -16, -43 }, { -1, -18 } )

   oControl := wvgtstEdit():New()
   oControl:Style += ES_NUMBER + ES_RIGHT
   oControl:cText := "1234567"
   oControl:Create( , , { -17, -43 }, { -1, -18 } )

   oControl := wvgtstButton():New()
   oControl:cText := "OK"
   oControl:Create( , , { -20, -50 }, { -1, -8 } )
   wvgSetAppWindow():Refresh()

   //oControl := wvgtstProgressbar():New()
   //oControl:Create( , , { -23, -1 }, { -1, -50 } )
   //oControl:SetValues( 15, 1, 20 )

   //oControl := wvgtstStatusbar():New()
   //oControl:Create( , , { -28, 1 }, { -1, -50 } )

   oControl := wvgtstFrame():New()
   oControl:Create( , , { -23, -62 }, { -1, -Len( cText ) } )
   @ 23, 62 SAY "This is a SAY"

   SetColor( "N/W,N/W,,,N/W" )
   oControl := wvgtstGroupBox():New()
   oControl:cText := "This is a get"
   oControl:Create( , , { -24, -60 }, { -2, -Len( cText ) - 4 } )

   //oControl := wvgtstFrame():New()
   //oControl:Create( , , { -25, -62 }, { -1, -Len( cText ) } )
   @ 25, 62 GET cText
   READ
   Inkey(0)

   RETURN

FUNCTION GetEditText()

   RETURN Replicate( Space(10) + hb_Eol(), 10 )
   //   "This sample is to show GTWVG possibilites." + hb_eol() + ;
   //   "It does not use existing GTWVG controls," + hb_eol() + ;
   //   "but uses features of GTWVG." + hb_eol() + ;
   //   "Think possibilites to expand." + hb_eol()
