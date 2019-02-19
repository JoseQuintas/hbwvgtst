/*
ZE_CHART - Gráfico de barras simples
2016.05 - José Quintas
*/

#include "hbclass.ch"

CREATE CLASS BarChartClass

   VAR    cTxtTitle            INIT ""
   VAR    aTxtBarList          INIT {}
   VAR    aTxtSubList          INIT {}
   VAR    aValues              INIT {}
   VAR    nTop                 INIT 0
   VAR    nLeft                INIT 0
   VAR    nBottom              INIT MaxRow()
   VAR    nRight               INIT MaxCol()
   METHOD Show()

   VAR    nMaxValue            INIT 10
   VAR    nIncrement           INIT 1
   VAR    nGradeCount          INIT 5
   METHOD CalcMaxValue()
   METHOD ShowEmpty()
   METHOD ShowColBar()
   METHOD ShowColSub( nNumBar, nColuna, nLarguraColuna )
   METHOD BarColor( nNumColor )

   ENDCLASS

METHOD BarchartClass:Show()

   ::CalcMaxValue()
   Scroll( ::nTop, ::nLeft, ::nBottom, ::nRight, 0 )
   ::ShowEmpty()
   ::ShowColBar()

   RETURN NIL

METHOD BarchartClass:CalcMaxValue()

   LOCAL oBarElement, oSubElement, nReduce

   FOR EACH oBarElement IN ::aValues
      FOR EACH oSubElement IN oBarElement
         ::nMaxValue := Max( ::nMaxValue, oSubElement )
      NEXT
   NEXT
   DO WHILE .t.
      ::nIncrement *= 10
      IF ::nIncrement * ::nGradeCount > ::nMaxValue
         EXIT
      ENDIF
   ENDDO
   nReduce := ::nIncrement / 10
   DO WHILE ( ( ::nIncrement - nReduce ) * ::nGradeCount ) > ::nMaxValue
      ::nIncrement := ::nIncrement - nReduce
   ENDDO
   ::nIncrement := Max( ::nIncrement, nReduce )
   ::nMaxValue  := ::nIncrement * ::nGradeCount

   RETURN NIL

METHOD BarchartClass:ShowEmpty()

   LOCAL nCont, oElement

   // Título
   @ ::nTop, Int( ( ::nRight - ::nLeft - 1 - Len( ::cTxtTitle ) ) / 2 ) SAY " " + ::cTxtTitle + " " COLOR "N/W"

   // Linhas horizontal/vertical
   @ ::nTop + 2, ::nLeft + 12 TO ::nBottom - 3, ::nLeft + 12
   @ ::nBottom - 3, ::nLeft + 12 TO ::nBottom - 3, ::nRight - 2

   // Valores da barra vertical
   FOR nCont = 1 TO ::nGradeCount
      @ ::nBottom - 3 - ( ( ::nBottom - ::nTop - 6 ) / ::nGradeCount * nCont ), ::nLeft SAY nCont * ::nIncrement PICTURE "9999999999"
      @ Row(), ::nLeft + 13 TO Row(), ::nRight - 3
   NEXT

   // Legenda
   @ ::nBottom - 1, ::nLeft SAY ""
   FOR EACH oElement IN ::aTxtSubList
      @ Row(), Col() + 2 SAY Space(2) COLOR ::BarColor( oElement:__EnumIndex )
      @ Row(), Col() + 2 SAY oElement
   NEXT

   RETURN NIL

METHOD BarchartClass:ShowColBar()

   LOCAL nCont, nLarguraColuna

   nLarguraColuna := Int( ( ::nRight - ::nLeft - 11 ) / ( Len( ::aValues[ 1 ] ) + 1 ) )

   // cada grupo do gráfico
   FOR nCont = 1 TO Len( ::aTxtBarList )
      ::ShowColSub( nCont, 13 + ( ( nCont - 1 ) * nLarguraColuna ), nLarguraColuna )
   NEXT

   RETURN NIL

METHOD BarchartClass:ShowColSub( nNumBar, nColuna, nLarguraColuna )

   LOCAL oElement, cColorOld, nRow

   cColorOld := SetColor()

   // barras de comparação
   FOR EACH oElement IN ::aTxtSubList
      nRow := ::nBottom - ( ( ::nBottom - ::nTop - 2 ) * ::aValues[ oElement:__EnumIndex, nNumbar ] / ::nMaxValue )
      SetColor( ::BarColor( oElement:__EnumIndex ) )
      @ nRow, nColuna + oElement:__EnumIndex CLEAR TO ::nBottom - 4, nColuna + oElement:__EnumIndex
   NEXT
   SetColor( cColorOld )
   // legenda de cada coluna do gráfico
   @ ::nBottom - 2, nColuna + 1 SAY Pad( ::aTxtBarList[ nNumBar ], nLarguraColuna - 1 )

   RETURN NIL

METHOD BarchartClass:BarColor( nNumColor )

   DO CASE
   CASE nNumColor == 1 ; RETURN "9/9"
   CASE nNumColor == 2 ; RETURN "14/14"
   CASE nNumColor == 3 ; RETURN "15/15"
   CASE nNumColor == 4 ; RETURN "11/11"
   CASE nNumColor == 5 ; RETURN "12/12"
   ENDCASE

   RETURN "N/W"
