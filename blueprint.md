# Trivial de la Ciberseguretat - Blueprint

## 1. Visió General del Projecte

L'objectiu d'aquest projecte és desenvolupar una aplicació mòbil i web del "Trivial de la Ciberseguretat" basada en el joc de taula de l'Oficina de Seguretat de l'Internauta (OSI). L'aplicació ha de ser un joc interactiu, educatiu i entretingut per a usuaris de totes les edats, dissenyat per a 2-4 jugadors.

El joc consistirà en un tauler virtual on els jugadors es mouran llançant un dau. Cada casella correspondrà a una de les sis categories de ciberseguretat. En caure en una casella, el jugador haurà de respondre una pregunta d'opció múltiple. Si encerta, continua el seu torn. L'objectiu final és aconseguir els 6 "Ciberpunts" (un per cada categoria), que s'obtenen en respondre correctament a les preguntes de les caselles especials del tauler.

### Categories del Joc:
- Gestió de contrasenyes
- Compres en línia
- Xarxes socials i missatgeria instantània
- Protecció de dispositius
- Navegació segura
- Fraus en línia

## 2. Historial i Estat Actual del Desenvolupament

El desenvolupament s'ha realitzat de manera iterativa, abordant i solucionant problemes a mesura que sorgien. A continuació es detalla l'evolució del projecte.

**Fase 1: Estructura Base i Models de Dades (Completada)**

- **Objectiu:** Establir una base de codi sòlida.
- **Passos Realitzats:**
  1.  **Refactorització dels Models (`game_models.dart`, `board_square.dart`):** Es van redissenyar els models inicials per a una major claredat i funcionalitat. Es va crear el model `BoardSquare` per a les caselles individuals i es van adaptar les preguntes a un format d'opció múltiple.
  2.  **Actualització de les Dades (`questions.dart`):** Es va actualitzar el banc de preguntes per alinear-se amb el nou model de dades.

**Fase 2: Implementació de la Lògica i la UI (Completada)**

- **Objectiu:** Construir la interfície principal del joc i la lògica subjacent.
- **Passos Realitzats:**
  1.  **Pantalla d'Inici (`home_screen.dart`):** Creació d'una pantalla per introduir els noms dels jugadors.
  2.  **Pantalla de Joc (`game_screen.dart`):** Implementació de la pantalla principal que integra el tauler i els controls.
  3.  **Tauler Gràfic (`game_board_widget.dart`):** Creació d'un widget personalitzat (`CustomPaint`) per dibuixar el tauler de joc amb la seva topologia d'anell i branques.
  4.  **Panell de Control (`game_control_panel.dart`):** Desenvolupament d'un widget per mostrar la informació del torn, el resultat del dau i el botó per llançar-lo.

**Fase 3: Refinament i Correcció d'Errors (Completada)**

- **Objectiu:** Polir la lògica del joc, corregir errors de funcionament i millorar l'experiència d'usuari basant-se en els requisits inicials.
- **Fites Aconseguides:**
  1.  **Implementació de la Topologia del Tauler (`game_models.dart`):** Es va crear el mètode `GameBoard.createStandardBoard` per generar un tauler basat en un graf de connexions, definint l'anell exterior i les sis branques que connecten al centre. Aquest graf és la base per a la lògica de moviment.
  2.  **Lògica de Moviment Basada en Grafs (`game_models.dart`):** Es va implementar `getPossibleMoves`, una funció que calcula les destinacions possibles d'un jugador basant-se en el resultat del dau i les connexions del graf, permetent moviments en qualsevol direcció.
  3.  **Correcció d'Avisos de Codi Obsolet (`game_board_widget.dart`):** Es van substituir les crides a `.withOpacity()` per `.withAlpha()`, eliminant els avisos del linter de Flutter i modernitzant el codi.
  4.  **Correcció de la Lògica de Ciberpunts (`game_models.dart`):** Es va solucionar un error que duplicava les caselles de Ciberpunt. La nova implementació assegura que hi ha exactament **una casella de Ciberpunt per a cada categoria**, situada a la intersecció de cada branca amb l'anell exterior.
  5.  **Millora de l'Experiència de Llançament del Dau (`game_screen.dart`):** Es va modificar la funció `_rollDice` per introduir una pausa visual. Ara, primer es mostra el resultat del dau i, un instant després, s'il·luminen les caselles on es pot moure, fent el flux del joc més clar i menys abrupte.
  6.  **Garantia de Categories Adjacents Diferents (`game_models.dart`):** Es va perfeccionar l'algorisme de generació del tauler per assegurar que **cap casella adjacent tingui la mateixa categoria**. Això s'aconsegueix mitjançant un algorisme de "coloring" voraç, que assigna a cada casella una categoria aleatòria d'entre les que no estan presents a les seves veïnes immediates.

## Estat Actual

El projecte té una base funcional sòlida i compleix amb totes les regles de lògica i disseny del tauler especificades. Els següents passos podrien incloure l'addició d'animacions, efectes de so, persistència de l'estat del joc o la publicació a les botigues d'aplicacions.
