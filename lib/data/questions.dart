
import '../models/game_models.dart';

const List<Question> trivialQuestions = [
  // Gestió de contrasenyes
  Question(
    text: 'Quina és la millor pràctica per crear una contrasenya segura?',
    category: CyberCategory.passwordManagement,
    options: [
      'Fer servir el nom de la teva mascota.',
      'Una paraula del diccionari seguida d\'un número.',
      'Una combinació llarga de lletres, números i símbols.',
      '"contrasenya123".',
    ],
    correctOptionIndex: 2,
    explanation: 'Les contrasenyes llargues i complexes són més difícils de desxifrar per atacs de força bruta.',
  ),
  Question(
    text: 'És segur reutilitzar la mateixa contrasenya per a diferents serveis?',
    category: CyberCategory.passwordManagement,
    options: [
      'Sí, si és una contrasenya molt forta.',
      'Només per a serveis poc importants.',
      'Sí, estalvia temps.',
      'No, mai.',
    ],
    correctOptionIndex: 3,
    explanation: 'Si un servei és compromès, totes les teves altres contes amb la mateixa contrasenya estarien en risc.',
  ),

  // Compres en línia
  Question(
    text: "Què has de buscar a la barra d'adreces del navegador abans d'introduir dades de pagament?",
    category: CyberCategory.onlineShopping,
    options: [
      "Un cadenat tancat i 'https://'.",
      "El logo de la botiga.",
      "Que la pàgina carregui ràpid.",
      "Una icona de cistella de la compra.",
    ],
    correctOptionIndex: 0,
    explanation: "'https://' indica que la connexió està xifrada i és segura per a transmetre dades sensibles.",
  ),
   Question(
    text: "Si un preu sembla massa bo per ser veritat, què hauries de fer?",
    category: CyberCategory.onlineShopping,
    options: [
      "Comprar-ho ràpidament abans que s'acabi l'oferta.",
      "Investigar la reputació del venedor i buscar ressenyes.",
      "Compartir l'oferta amb els amics.",
      "Introduir les dades de la targeta per reservar-ho.",
    ],
    correctOptionIndex: 1,
    explanation: "Les ofertes irreals solen ser un esquer per a estafes. Sempre verifica la fiabilitat del venedor.",
  ),

  // Xarxes socials i missatgeria
  Question(
    text: "Quina informació personal és millor no compartir públicament a les xarxes socials?",
    category: CyberCategory.socialMedia,
    options: [
      "La teva pel·lícula preferida.",
      "Una foto del teu dinar.",
      "Adreça de casa, número de telèfon i plans de vacances.",
      "El nom de la teva mascota.",
    ],
    correctOptionIndex: 2,
    explanation: "Compartir massa informació pot exposar-te a robatoris, suplantació d'identitat i altres riscos.",
  ),
   Question(
    text: "Reps un missatge d'un amic amb un enllaç sospitós i un text estrany. Què fas?",
    category: CyberCategory.socialMedia,
    options: [
      "Fer clic a l'enllaç per veure de què es tracta.",
      "Preguntar al teu amic per un altre mitjà si ha enviat ell el missatge.",
      "Reenviar-ho a altres contactes.",
      "Ignorar el missatge.",
    ],
    correctOptionIndex: 1,
    explanation: "El compte del teu amic podria haver estat segrestat per difondre malware o phishing.",
  ),

  // Protecció de dispositius
  Question(
    text: "Quina és una funció essencial del programari antivirus?",
    category: CyberCategory.deviceProtection,
    options: [
      "Netejar la pols de l'ordinador.",
      "Accelerar la connexió a Internet.",
      "Detectar i eliminar programari maliciós (malware).",
      "Fer còpies de seguretat dels teus arxius.",
    ],
    correctOptionIndex: 2,
    explanation: "L'antivirus protegeix el teu dispositiu de virus, troians i altres amenaces que poden robar informació.",
  ),
  Question(
    text: "Per què és important mantenir el sistema operatiu i les aplicacions actualitzades?",
    category: CyberCategory.deviceProtection,
    options: [
      "Perquè les noves versions tenen icones més boniques.",
      "Per corregir vulnerabilitats de seguretat que els atacants podrien explotar.",
      "Perquè ocupa més espai al disc dur.",
      "Perquè fa que l'ordinador vagi més lent.",
    ],
    correctOptionIndex: 1,
    explanation: "Les actualitzacions de seguretat són crucials per protegir el dispositiu contra les últimes amenaces descobertes.",
  ),

  // Navegació segura
  Question(
    text: "Què pot indicar un correu electrònic de 'phishing'?",
    category: CyberCategory.safeBrowsing,
    options: [
      "Una salutació personalitzada amb el teu nom.",
      "Errors gramaticals, un remitent sospitós i enllaços estranys.",
      "Un logotip oficial de l'empresa.",
      "Informació sobre una compra que vas fer.",
    ],
    correctOptionIndex: 1,
    explanation: "El phishing intenta enganyar-te perquè revelis informació confidencial fent-se passar per una entitat de confiança.",
  ),
  Question(
    text: "Què és una xarxa Wi-Fi pública no segura?",
    category: CyberCategory.safeBrowsing,
    options: [
      "Una xarxa Wi-Fi a casa d'un amic.",
      "La xarxa Wi-Fi de la teva feina.",
      "Una xarxa oberta en un aeroport o cafeteria sense contrasenya.",
      "Una xarxa protegida amb WPA2.",
    ],
    correctOptionIndex: 2,
    explanation: "Les xarxes públiques no segures poden ser interceptades per atacants. Evita fer transaccions sensibles en elles.",
  ),
  
  // Fraus en línia
  Question(
    text: "Reps una oferta de treball que sembla massa bona per ser veritat i et demana diners per començar. Què fas?",
    category: CyberCategory.onlineFraud,
    options: [
      "Pagar la quantitat, sembla una bona inversió.",
      "Enviar el teu currículum i dades personals.",
      "Ignorar-la i eliminar-la, és un frau comú.",
      "Demanar un préstec per poder pagar.",
    ],
    correctOptionIndex: 2,
    explanation: 'Les ofertes de treball legítimes mai et demanaran que paguis per començar a treballar.',
  ),
   Question(
    text: "Ganyes un premi en un sorteig al qual no recordes haver participat. Per reclamar-lo, et demanen les dades bancàries. Què fas?",
    category: CyberCategory.onlineFraud,
    options: [
      "Donar les teves dades, és un cop de sort!",
      "Tancar el missatge, probablement és una estafa per robar-te les dades.",
      "Comprovar si el premi és real en un altre lloc.",
      "Compartir la notícia a les xarxes socials.",
    ],
    correctOptionIndex: 1,
    explanation: "Aquesta és una tàctica molt comuna per al robatori d'informació financera. No caiguis en el parany.",
  ),
];
