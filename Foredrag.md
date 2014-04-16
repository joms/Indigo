# Hva er en demo?
For å kunne si hva en demo er må vi gå litt tilbake i tid – helt til rundt 1980, når datamaskiner begynte å bli allemannseie. Og med datamaskinene kom spillene, og med spillene kom også cracks, der kløktige unge mennesker hadde fjernet kopibeskyttelsen for å fritt kunne dele spillene mellom seg. I begynnelsen var det gjerne enkeltpersoner, men etter hvert begynte man også å sample seg i grupper. Med gruppene kom gjerne et markeringsbehov, og et konkurranseinstinkt. Gruppene konkurrerte seg imellom å komme først med sin versjon av nye spill, og det ble viktig å ha den kuleste crack-introen foran spillet – en liten vignett som viste hvem som hadde cracket spillet.   

Denne utviklingen skjedde gradvis fra 1984 og framover, og mot slutten av 1986 begynte mange ting å falle på plass for denne scenen. Man hadde bygget en hel kultur rundt dette med crack-introene – det vi i dag kjenner som demoscenen 
Det er også på denne tiden vi begynner å se navn som vi enda kan se dukke opp – som Fairlight og Triad, begge med sitt opphav i Sverige. Når man hadde cracket et spill, så måtte det gjerne skapes plass til disse introene, og det ble også en konkurranse om hvem som kunne få pakket spillene ned i minst størrelse, slik at det ble plass til de feteste introene, eller til og med flere spill på en diskett.

På slutten av -86 begynte også de skikkelige datapartyene å dukke opp. De ble ofte kalt copy-parties, siden det var en gylden anledning til å kopiere så mye som overhodet mulig. Dette var jo før internett, og for de aller fleste før BBS’ene, så tilgangen på ny software måtte skje fysisk – enten ved at man kopierte av venner eller andre i miljøet. Eller ved at man sendte disketter gjennom posten.

Fram til nå hadde demoscenen stort sett dreit seg om cracka spill og introene, men i -87 begynte enkelte grupper å lage rene demoer – ofte ved at flere introer var lenket sammen til en helhet. Det var også nå at scenen for alvor ble multi-plattform. Mye av det vi kjenner som scenen i dag oppstod på Commodore 64, men nå begynte det for alvor å komme produksjoner til storebror Amiga – og til en viss grad også andre plattformer som Atari ST. 1987 ble også året det ble en eksplosjon i antallet partyer over hele Europa, med Tyskland, Danmark og Sverige i føringen.

I Norge fikk vi ikke vårt første dataparty før året etter, da bruppene Abnormal, The Cartel og Razor 1911 arrangerte copy-parti i Stjørdal, nær Trondheim. Det var nå vanlig med konkurranser på partyene, og da ikke bare for demoer, men også grafikk og musikk. Det var nå også for lengst blitt vanlig med «rene» demogrupper, som ikke hadde noen fot i cracking-scenen. Fokus endret seg sakte fra et markeringsbehov for å sette fokus på sine evner som spillcracker, til å ha et fokus på å lage så fete effekter som mulig, og ha den beste grafikken og musikken. Man kan si at demoscenen hadde blitt født og modnet på noen få år, og nå hadde langt på vei funnet sin egen form.

Så er vi her – i 2014. Demoscenen lever i beste velgående. Mye er annerledes siden den gang, men mye er også likt. Det er fortsatt demopartyer i store deler av Europa (og etter hvert også i USA og Asia), og at man konkurrerer fortsatt i grafikk og musikk. Man konkurrerer fortsatt om beste demo, selv om uttrykksformen har endret seg en hel del med inntoget av 3D-grafikk og kraftige datamaskiner som åpner for helt nye utfordringer. I tillegg har man også gjerne intro-konkurranser, der man skal lage noe så kult som mulig innenfor en gitt ramme – det er enkelt å dra parallellene tilbake i tid til da man forsøkte å få plass til så mye som mulig på spilldiskettene.

Om du aldri har vært på et demoparty før, så synes jeg du skal gjøre noe med det allerede i år. Norge har flere gode alternativer – Solskogen finner sted i juli bare en liten bussreise fra Oslo, og Kindergarden i novemter – en halvtimes togreise fra oslo. Demoscenen er en inkluderende subkultur, og det er absolutt lov å bare komme for å se og snakke med folk, selv om man ikke kjenner noen fra før.

# Årets invite

En invite er da en demo som forteller om hva som skjer hvor og når. Det har vært en tradisjon at det blir sluppet en invite for hvert The Gathering, selv om det meste skjer på nett i dag. Dette er en fin påminnelse om hvor The Gathering kommer fra.
Årets invite ble jeg spurt om å lage, og tok med meg Liam på laget for programmering. 

Valget av språk falt på et programmeringsspråk kalt Uno – Det er fortsatt under utvikling, og lages av demogruppen Outracks. Det spesielle med dette språket er at de slår sammen shaderkode og prosessorkode til ett og samme språk.
Det kan også kompilere prosjekter til mange forskjellige plattformer – inviten kan per dags dato kompileres til både .NET og WebGL, samt at den veldig teoretisk kan kompileres til android.

I IDEen som man gjerne bruker til å programmere Uno – Realtime Studio, kan man også ta nytte av et nodeview og et animasjonsverktøy. Nodeviewet gir deg enkel tilgang til alle komponentene i en scene, og deres egenskaper. Animasjonsverktøyet gir tilgang til å styre de samme komponentene over en tidslinje – alt i alt et perfekt verktøy for å lage spill og demoer.

# Scene 1

Den første scenen er mye enklere enn det ser ut som ved første øyekast. Den består mer eller mindre av.
Den er bygd opp av 3 lag med tiles. Hver tile har så fått lagt på et lag med Emissive Material – et materiale som gjør at det ser ut som om objektet gløder.

Det siste vi så gjorde var å slenge på en Radial Blur shader skrevet av Remi Pedersen som jobber i Outracks.
En tilegrid som vi har lagd her er veldig enkel å gjenskape. Det vi har gjort er å lage et grunnobjekt, som vi så kloner flere ganger og plasserer utover i en grid. På denne måten kan vi veldig enkelt styre materialet for hver grid så vi kan endre effekten.

Det fine med hvordan denne scenen er satt opp, er at Uno sin Batcher-funksjon skal trå til. Dette er en funksjon som kan tegne store mengder 3D-objekter på ett og samme tegnekall. Dette gjør at man ikke nødvendigvis taper mye kraft på å tegne store mengder geometri. Om man skriver sin egen Batcher vil det være enda kjappere enn den som automagiske batcheren. Dette vil Liam fortelle litt mer om senere.

# Scene 2

I den andre scenen er det store å snakke om trærne og partiklene.   
På partiklene brukte vi akkurat samme teknikk som med tilegriden, det er rett og slett en sfære som er klonet ut over en grid, og lagt på glow. Deretter animerer vi denne ved å gjøre en enkel sinus på høydekoordinaten samtidig som hele griden flyttes rundt. Med disse enkle tricksene endte vi med en ganske kul partikkeleffekt som ser ut som partikler som flyter rundt i verden.

Trærne er dynamisk genererte fraktaler, eller mer nøyaktig Pythagoras Tree. Dette er en funksjon som starter på rot, deretter tegner den to grener i hver sin retning, skalerer de ned, tegner to nye grener osv. Dette ender til slutt med noe som ligner på et tre. Med litt mer spesifikke regler kan man ende opp med veldig kule trær.

Roboten sine armer har vi animert manuelt i Uno, noe det forsåvidt bærer preg av, men endte som en god løsning. Ettersom Uno gir oss muligheten til å kontrollere hver «del» av en modell, var det også veldig enkelt å si at øynene skulle ha et emissive material.

Den samme teknikken brukte vi på vinduene på Vikingskipet, bare at vi også knyttet opp en node som returnerer et tall som svinger mellom 0 og 1 for å justere styrken på glowen.

# Scene 3

Den tredje scenen er veldig enkel og ble mest en «filler»-scene for infoen på compoer. Denne er basert på en tutorial for Unity som beskriver hvordan du enkelt kan lage fete mønster i både 2D og 3D-space. Jeg anbefaler på det sterkeste at du sjekker denne tutorialen om dette er noe du syns høres interessant ut og vil lære mer!

Hele effekten bygger på at vi nok en gang kloner objekter, men denne gangen plasseres de ut i en kubeform. Deretter regulerer vi lysstyrken etter en gitt formel. Denne formelen har vi hentet fra [Unity Graphs](http://catlikecoding.com/unity/tutorials/graphs/).   
Deretter har vi slengt på radial blur shaderen som vi brukte i første scene.

# Scene 4

Her setter vi opp en manuell batcher med et høyt antall kuber som vi posisjonerer i en tunell. Det å sette opp en manuell batcher lar oss tegne flere punkter per bilde ettersom batcheren samler opp alle punktene i 3D-spacet for så å tegne alt på ett kall. 

Teksten er også lagd med batcheren, men her har vi på forhånd lagd et java-program som lar oss enkelt editere hver gruppes navn, som så blir lagret i et tekstformat. Dette tekstformatet parses så til batcheren som posisjonskoordinater.

# Scene 5

Terrenget er generert via en perlinfunksjon som er basert på en enkel versjon av hvordan Notch generer terrenget i Minecraft.
«Ormen» med kuber, er rett og slett kuber plassert ut langs en path. Denne pathen er generert av en manuelt implementert bezier curve.

Fargingen er gjort ved at vi sampler en perlin-tekstur, og deretter benytter oss av hvordan kubene er generert til å sjekke deres posisjon. På gitte regler vil da kuben endre farge til et annet colorscheme som vi har lagd på forhånd. 

