#include "inkey.ch"

PROCEDURE Main

   LOCAL aBarras := { "BARRA-1", "BARRA-2", "BARRA-3" }
   LOCAL aMeses := { "JAN", "FEV", "MAR", "ABR", "MAI" }
   LOCAL aValor := { ;
      { 1000, 2000, 3000, 4000, 5000 }, ;
      { 3000, 4000, 5000, 6000, 7000 }, ;
      { 5000, 6000, 7000, 5000, 4000 } }
   LOCAL oGrafico

   SetMode( 40, 100 )
   oGrafico := BarChartClass():New()
   oGrafico:nTop := 2
   oGrafico:nLeft := 0
   oGrafico:nBottom := MaxRow() - 3
   oGrafico:nRight := MaxCol()
   oGrafico:nGradeCount := 5
   oGrafico:cTxtTitle := "COMPARATIVO"
   oGrafico:aTxtSubList := aBarras
   oGrafico:aTxtBarList := aMeses
   oGrafico:aValues := aValor
   oGrafico:Show()
   Inkey(0)

   RETURN
