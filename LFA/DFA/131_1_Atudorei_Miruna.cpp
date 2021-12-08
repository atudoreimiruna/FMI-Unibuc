#include <iostream>
#include <fstream>
#include <vector>
#include <string>

using namespace std;

ifstream fin("fisier.in");
ofstream fout("fisier.out");

struct tranzitie{
    int stare_i, stare_f;   // starea initiala si cea finala
    char c;
}tr;

vector <tranzitie> Tranzitii;   
int F[1001];    // vectorul cu starile finale

int n, m;
int start, stop, nf, ni;
char cuv[100];

void Read()
{
    int x;
    // n = numarul de noduri
    // m = numarul de arce / tranzitii
    fin >> n >> m;  
    
    for ( int i = 0; i <= m; i++ )
    {
        // descrierea tranzitiilor din fiecare automat
        fin >> tr.stare_i >> tr.stare_f >> tr.c;
        Tranzitii.push_back(tr);
    }
    
    fin >> start;    // starea initiala
    fin >> nf;   // numarul de stari finale
    for ( int i = 0; i < nf; i++ )
        fin >> F[i];
}

void DFA( char cuvant[100] )
{
    vector <int> solutie;
    bool ok;
    int stare = start;
    solutie.push_back(stare);

    for ( int i = 0; cuvant[i]; i++ )
    {
        ok = 0;
        for ( int j = 0; j <= m; j++ )
            if ( Tranzitii[j].c == cuvant[i] && stare == Tranzitii[j].stare_i )
            {   
                ok = 1;
                stare = Tranzitii[j].stare_f;
                solutie.push_back(stare);
                break;
            }

        if ( ok == 0 )
        {
            fout << "NU" << "\n";
            break;
        }
    }
    
    bool ok2;
    if ( ok == 1 )
    {
        ok2 = 0;
        // verificam daca ultimul nod este valabil
        for ( int i = 0; i < nf; i++ )
            if ( solutie[strlen(cuvant)] == F[i])
            {
                ok2 = 1;
                break;
            }
        if ( ok2 == 1 )
        {
            fout << "DA" << "\n";
            for ( int i = 0; i < solutie.size(); i++ )
                fout << solutie[i] << " ";
            fout << "\n";
        }
        else fout << "NU" << "\n";
    }
}

int main()
{
    Read();
    fin >> ni;  // numarul de string-uri
    for ( int i = 0; i < ni; i++ )
    {
        fin >> cuv;
        DFA(cuv);
    }
    return 0;
}