// Conway’s Game of Life
/*
    * 1. Any live cell with fewer than two live neighbours dies, as if caused by under-population.
    * 2. Any live cell with two or three live neighbours lives on to the next generation.
    * 3. Any live cell with more than three live neighbours dies, as if by overcrowding.
    * 4. Any dead cell with exactly three live neighbours becomes a live cell, as if by reproduction.

*/
#include <iostream>
#include <fstream>
using namespace std;

ifstream f("input.txt");

int n, m; // dimensiunea matricei
int g;    // numarul de generatii
int p;    // numarul de celule vii
bool a[100][100];

// void bordare()
// {
//     for (int i = 0; i <= n + 1; i++)
//     {
//         a[0][i] = 0;
//         a[n + 1][i] = 0;
//     }
//     for (int i = 0; i <= m + 1; i++)
//     {
//         a[i][0] = 0;
//         a[i][m + 1] = 0;
//     }
// }

void afisare(bool afisBordata = false)
{
    if (afisBordata)
    {
        for (int i = 0; i <= n + 1; i++)
        {
            for (int j = 0; j <= m + 1; j++)
                cout << a[i][j] << " ";
            cout << endl;
        }
        return;
    }
    else
    {

        for (int i = 1; i <= n; i++)
        {
            for (int j = 1; j <= m; j++)
                cout << a[i][j] << " ";
            cout << endl;
        }
    }
}

int countVecini(int i, int j)
{
    int nrVecini = 0;
    if (a[i - 1][j - 1])
        nrVecini++;
    if (a[i - 1][j])
        nrVecini++;
    if (a[i - 1][j + 1])
        nrVecini++;
    if (a[i][j - 1])
        nrVecini++;
    if (a[i][j + 1])
        nrVecini++;
    if (a[i + 1][j - 1])
        nrVecini++;
    if (a[i + 1][j])
        nrVecini++;
    if (a[i + 1][j + 1])
        nrVecini++;

    return nrVecini;
}

void evolutie(int g)
{
    // se va face g evolutii dupa regulile de mai sus
    //loop k times
    //copy matrix in cp_matrix
    //loop elements in matrix
    //count neighbours
    //if matrix(elem)==1 && neighbours < 2 or neighbours > 3 set cp_matrix[i][j] = 0
    //else neighbours == 3 set cp_matrix[i][j] = 1
    // reset vecini
    // copy cp_matrix in matrix
    // end loop
    for (int i = 1; i <= g; i++)
    {
        // copy matrix
        int b[100][100];
        for (int i = 1; i <= n; i++)
            for (int j = 1; j <= m; j++)
                b[i][j] = a[i][j];

        // se va face o evolutie
        for (int i = 1; i <= n; i++)
            for (int j = 1; j <= m; j++)
            {
                int nrVecini = countVecini(i, j);
                if (a[i][j] == 1)
                {
                    if (nrVecini < 2)
                        b[i][j] = 0;
                    if (nrVecini > 3)
                        b[i][j] = 0;
                }
                else
                {
                    if (nrVecini == 3)
                        b[i][j] = 1;
                }
            }
        
        // copy back
        for (int i = 1; i <= n; i++)
            for (int j = 1; j <= m; j++)
                a[i][j] = b[i][j];

        
        // cout << "Evolutia " << i << endl;
        // afisare();
    }
}

void citire()
{
    int x, y;
    f >> n >> m >> p;
    for (int i = 1; i <= p; i++)
    {
        f >> x >> y;
        a[x + 1][y + 1] = 1;
    }
    f >> g;

    f.close();
    // bordare();
}

int main()
{
    cout << "Pula calului cu matricile voastre" << endl;
    citire();
    afisare();
    evolutie(g-1);
    cout << "After evolutie\n"
         << endl;
    afisare();

    // criptare();
    cout << countVecini(2, 2);
    // afisare(true);
    return 0;
}
