# Assembly x86 Conway’s Game of Life

Conway’s Game of Life este un zero-player game bidimensional, inventat de matematicianul John
Horton Conway in anul 1970. Scopul acestui joc este de a observa evolutia unui sistem de celule,
pornind de la o configuratie initiala, introducand reguli referitoare la moartea, respectiv crearea unei
noi celule in sistem. Acest sistem evolutiv este Turing-complete.
Starea unui sistem este descrisa de starea cumulata a celulelor componente, iar pentru acestea
avem urmatoarele reguli:
1. Subpopulare. Fiecare celula (care este in viata in generatia curenta) cu mai putin de doi
vecini in viata, moare in generatia urmatoare.
2. Continuitate celule vii. Fiecare celula (care este in viata in generatia curenta), cu doi sau
trei vecini in viata, va exista si in generatia urmatoare.
3. Ultrapopulare. Fiecare celula (care este in viata in generatia curenta), care are mai mult de
trei vecini in viata, moare in generatia urmatoare.
4. Creare. O celula moarta care are exact trei vecini in viata, va fi creata in generatia urmatoare.
5. Continuitate celule moarte. Orice alta celula moarta, care nu se incadreaza in regula de
creare, ramane o celula moarta.

> [Cerintele de Evaluare](https://cs.unibuc.ro/~crusu/asc/Arhitectura%20Sistemelor%20de%20Calcul%20(ASC)%20-%20Tema%20Laborator%202023.pdf)

