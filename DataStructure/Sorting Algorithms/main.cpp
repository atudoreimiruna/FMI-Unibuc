#include <iostream>
#include <stdlib.h>
#include <stdio.h>
#include <fstream>
#include <algorithm>

#include <chrono>

#define N 10000001

using namespace std;
using namespace std::chrono;

ifstream fin("fisier.in");
ofstream fout("fisier.out");

int tablou[N], copie_tablou[N];
int v_aux[N];
int frecventa[N];
int nr, nr_maxim;

// BUBBLE SORT

void BubbleSort(int v[], int nr_elemente)
{
    bool sort = 0;
    while ( sort == 0 )
    {
        sort = 1;
        for ( int i = 0; i < nr_elemente-1; i++ )
            if ( v[i] > v[i+1] )
            {
                swap ( v[i], v[i+1] );
                sort = 0;
            }
    }
}

// QUICK SORT

int Pivotare(int v[], int stg, int drp)
{
    int pasi, pasj;
    int i, j;

    pasi = 0; 
    pasj = 1;
    i = stg; 
    j = drp;

    while ( i < j )
    {
        if ( v[i] > v[j] )
        {
            swap( v[i], v[j] );
            pasi = 1 - pasi;
            pasj = 1 - pasj;
        }
        i = i + pasi;
        j = j - pasj;
    }
    return i;
}

void QuickSort(int v[], int stg, int drp)
{
    if ( stg < drp )
    {
        int p = Pivotare(v, stg, drp);
        QuickSort(v, stg, p-1);
        QuickSort(v, p+1, drp);
    }
}

// QUICK SORT CU PIVOT RANDOMIZAT

int PivotRandomizat(int v[], int stg, int drp)
{
    // generam un numar random intre stanga si dreapta
    int r, pivot;
    r = stg + rand() % ( drp - stg);
    pivot = v[r];
    int i, j;
    i = stg-1; j = drp+1;

    while ( true )
    {
        do
        {
            i++;
        } while ( v[i] < pivot );

        do
        {
            j--;
        } while ( v[j] > pivot );
        
        if ( i >= j )    
            return j;

        swap( v[i], v[j] ); 
    }
}

void QuickSortRand(int v[], int stg, int drp)
{
    if ( stg < drp )
    {
        int k = PivotRandomizat(v, stg, drp);
        QuickSortRand(v, stg, k);
        QuickSortRand(v, k+1, drp);
    }
}

// QUICK SORT CU PIVOTUL FIIND MEDIANA DIN 3

void Swap(int v[], int i, int j)
{
    int aux;
    aux = v[i];
    v[i] = v[j];
    v[j] = aux;
}

int Mediana(int v[], int stg, int drp)
{
    int mijloc = ( stg + drp ) / 2;
    if ( v[drp] < v[stg] ) Swap(v, stg, drp);
    if ( v[mijloc] < v[stg] ) Swap(v, mijloc, stg);
    if ( v[drp] < v[mijloc] ) Swap(v, drp, mijloc);
    return mijloc;
}

int PivotMOT(int v[], int stg, int drp)
{
    int mijloc = Mediana(v, stg, drp);
    int pivot = v[mijloc];

    int i, j;
    i = stg-1; j = drp+1;

    while ( true )
    {
        do
        {
            i++;
        } while ( v[i] < pivot );

        do
        {
            j--;
        } while ( v[j] > pivot );
        
        if ( i >= j )    
            return j;

        swap( v[i], v[j] ); 
    }
}

void QuickSortMOT(int v[], int stg, int drp)
{
    if ( stg < drp )
    {
        int k = PivotMOT(v, stg, drp);
        QuickSortMOT(v, stg, k);
        QuickSortMOT(v, k+1, drp);
    }
}

// MERGE SORT

void Interclasare(int v[], int stg, int mijloc, int drp)
{
    int i, j, k;
    i = stg; j = mijloc+1; k = 0;
    while ( i <= mijloc && j <= drp )
        if ( v[i] < v[j] ) 
            v_aux[++k] = v[i++];
        else 
            v_aux[++k] = v[j++];
    while ( i <= mijloc ) 
        v_aux[++k] = v[i++];
    while ( j <= drp ) 
        v_aux[++k] = v[j++];
    for ( i = stg, j = 1; i <= drp; i++, j++ ) v[i] = v_aux[j];
}

void MergeSort(int v[], int stg, int drp)
{
    if ( stg < drp )
    {
        int mijloc = ( stg + drp ) / 2;
        MergeSort(v, stg, mijloc);
        MergeSort(v, mijloc+1, drp);
        Interclasare(v, stg, mijloc, drp);
    }
}

// COUNT SORT

void CountSort(int v[], int nr_elemente)
{
    int maxi = v[0], k = 0;
    for ( int i = 1; i < nr_elemente; i++ )
    {
        if ( v[i] > maxi )
            maxi = v[i];    
    }

    for ( int i = 0; i <= maxi; i++ )
        frecventa[i] = 0;   

    for ( int i = 0; i < nr_elemente; i++ )
        frecventa[v[i]]++;  

    for ( int i = 0; i <= maxi; i++ )
        if ( frecventa[i] != 0 )
            for ( int j = 0; j < frecventa[i]; j++ ) // worst case - for-ul va merge pana la n
                v_aux[++k] = i;
    
    for ( int i = 0; i < nr_elemente; i++ )
        v[i] = v_aux[i];
}

// RADIX SORT - LSD ( least significant digit ) - stabil
// Pentru acest algoritm am ales baza 10 pentru a fi usor de modificat in 100

 int NumarMaxim(int v[], int nr_elemente)
 {
    int maxi = v[0];
    for ( int i = 1; i < nr_elemente; i++ )
        if ( v[i] > maxi )
            maxi = v[i];  
    return maxi;
 }

 void CountSortforRadix(int v[], int nr_elemente, int exp)
 {
    int frecventa[10] = {0};

    for ( int i = 0; i < nr_elemente; i++ )
        frecventa[(v[i] / exp) % 10]++;

    for ( int i = 1; i < 10; i++ )
        frecventa[i] += frecventa[i-1];
    
    for ( int i = nr_elemente-1; i >= 0; i-- )
    {
        v_aux[frecventa[(v[i]/exp) % 10] - 1] = v[i];
        frecventa[ (v[i]/exp) % 10]--;
    }

    for ( int i = 0; i < nr_elemente; i++ )
        v[i] = v_aux[i];
 }

void RadixSort(int v[], int nr_elemente)
{
    int maxi = NumarMaxim(v, nr_elemente);
    int exp = 1;
    while ( maxi > 0 )
    {
        CountSortforRadix(v, nr_elemente, exp);
        maxi /= exp;
        exp *= 10;
    }
}

int Test_Sortat(int v[], int nr_elemente)
{
    for ( int i = 0; i < nr_elemente; i++ )
        if ( v[i] > v[i+1] )
            return false;
    return true;
}

void CreareVectorRandom(int v[], int nr, int nr_maxim)
{
    for ( int i = 0; i < nr; i++ )
        v[i] = rand() % nr_maxim;
}

void CopiereVector(int v[], int copie_v[], int nr_elemente)
{
    for ( int i = 0; i < nr_elemente; i++ )
        v[i] = copie_v[i];
}

int main()
{
    int teste;
    // Pe prima linie numărul de teste apoi pentru fiecare test 
    // cate numere trebuie sortate și care este cel mai mare număr.
    fin >> teste;
    int i = 1;
    while ( i <= teste )
    {
        fin >> nr >> nr_maxim;
        fout << nr << " " << nr_maxim << "\n";

        CreareVectorRandom(tablou, nr, nr_maxim);
        CopiereVector(tablou, copie_tablou, nr);

        auto start = high_resolution_clock::now();
        auto stop = high_resolution_clock::now();
        auto duration = duration_cast<milliseconds>(stop - start);
        
        // BubbleSort

        if ( nr <= 50000 )
        {
            start = high_resolution_clock::now();
            BubbleSort(tablou, nr);
            stop = high_resolution_clock::now();            
            duration = duration_cast<milliseconds>(stop - start);
            fout << "BubbleSort " << duration.count() / 1000 << " milisecunde " << Test_Sortat(tablou, nr);
            fout << endl;
            CopiereVector(tablou, copie_tablou, nr);
            fout << endl;
        }
        else
        {
            fout << "BubbleSort nu este eficient pentru tablouri foarte mari.";
            fout << endl;
        }

        // CountSort

        if ( nr_maxim <= 100000 )
        {
            start = high_resolution_clock::now();
            CountSort(tablou, nr);
            stop = high_resolution_clock::now();
            duration = duration_cast<milliseconds>(stop - start);
            fout << "CountSort " << duration.count() / 1000 << " milisecunde " << Test_Sortat(tablou, nr);
            fout << endl;
            CopiereVector(tablou, copie_tablou, nr);
            fout << endl;
        }
        else 
        {
            fout << "CountSort nu este eficient pentru numere mari.";
            fout << endl;
        }
        
        // RadixSort cu baza 10

        start = high_resolution_clock::now();
        RadixSort(tablou, nr);
        stop = high_resolution_clock::now();
        duration = duration_cast<milliseconds>(stop - start);            
        fout << "RadixSort " << duration.count() / 1000 << " milisecunde " << Test_Sortat(tablou, nr);
        fout << endl;
        CopiereVector(tablou, copie_tablou, nr);
        fout << endl;

        // MergeSort

        start = high_resolution_clock::now();
        MergeSort(tablou, 1, nr);
        stop = high_resolution_clock::now();
        duration = duration_cast<milliseconds>(stop - start);            
        fout << "MergeSort " << duration.count() / 1000 << " milisecunde " << Test_Sortat(tablou, nr);
        fout << endl;
        CopiereVector(tablou, copie_tablou, nr);
        fout << endl;

        // QuickSort

        start = high_resolution_clock::now();
        QuickSort(tablou, 0, nr-1);
        stop = high_resolution_clock::now();
        duration = duration_cast<milliseconds>(stop - start);            
        fout << "QuickSort " << duration.count() / 1000 << " milisecunde " << Test_Sortat(tablou, nr);
        fout << endl;
        CopiereVector(tablou, copie_tablou, nr);
        fout << endl;

        // QuickSort cu pivot random

        start = high_resolution_clock::now();
        QuickSortRand(tablou, 0, nr-1);
        stop = high_resolution_clock::now();
        duration = duration_cast<milliseconds>(stop - start);            
        fout << "QuickSortRand " << duration.count() / 1000 << " milisecunde " << Test_Sortat(tablou, nr);
        fout << endl;
        CopiereVector(tablou, copie_tablou, nr);
        fout << endl;

        // QuickSort mediana din 3
        
        start = high_resolution_clock::now();
        QuickSortMOT(tablou, 0, nr-1);
        stop = high_resolution_clock::now();
        duration = duration_cast<milliseconds>(stop - start);            
        fout << "QuickSortMOT " << duration.count() / 1000 << " milisecunde " << Test_Sortat(tablou, nr);
        fout << endl;
        CopiereVector(tablou, copie_tablou, nr);
        fout << endl;
        
        // Sort din STL

        start = high_resolution_clock::now();
        sort(tablou+0, tablou+nr);
        stop = high_resolution_clock::now();            
        duration = duration_cast<milliseconds>(stop - start);            
        fout << "Functia sort din STL " << duration.count() / 1000 << " milisecunde " << Test_Sortat(tablou, nr);
        fout << endl;
        CopiereVector(tablou, copie_tablou, nr);
        fout << endl;

        i++;
    }

    // Pentru vector deja sortat

    fout<<endl<<"Vector deja sortat: "<<endl;
    fin >> nr >> nr_maxim;
    CreareVectorRandom(tablou, nr, nr_maxim);
    fout << nr << " " << nr_maxim << "\n";
    sort(tablou+0, tablou+nr);
    auto start = high_resolution_clock::now();
    auto stop = high_resolution_clock::now();
    auto duration = duration_cast<milliseconds>(stop - start);
    
    // Bubble Sort

    if ( nr <= 50000 )
    {
        start = high_resolution_clock::now();
        BubbleSort(tablou, nr);
        stop = high_resolution_clock::now();            
        duration = duration_cast<milliseconds>(stop - start);
        fout << "BubbleSort " << duration.count() / 1000 << " milisecunde " << Test_Sortat(tablou, nr);
        fout << endl;
    }
    else
    {
        fout << "BubbleSort nu este eficient pentru tablouri foarte mari.";
        fout << endl;
    }

    // CountSort

    if ( nr_maxim <= 100000 )
    {
        start = high_resolution_clock::now();
        CountSort(tablou, nr);
        stop = high_resolution_clock::now();
        duration = duration_cast<milliseconds>(stop - start);
        fout << "CountSort " << duration.count() / 1000 << " milisecunde " << Test_Sortat(tablou, nr);
        fout << endl;
    }
    else
    {
        fout << "CountSort nu este eficient pentru numere mari.";
        fout << endl;
    }
    
    // RadixSort cu baza 10

    start = high_resolution_clock::now();
    RadixSort(tablou, nr);
    stop = high_resolution_clock::now();
    duration = duration_cast<milliseconds>(stop - start);            
    fout << "RadixSort " << duration.count() / 1000 << " milisecunde " << Test_Sortat(tablou, nr);
    fout << endl;

    // MergeSort

    start = high_resolution_clock::now();
    MergeSort(tablou, 1, nr);
    stop = high_resolution_clock::now();
    duration = duration_cast<milliseconds>(stop - start);            
    fout << "MergeSort " << duration.count() / 1000 << " milisecunde " << Test_Sortat(tablou, nr);
    fout << endl;

    // QuickSort

    start = high_resolution_clock::now();
    QuickSort(tablou, 0, nr-1);
    stop = high_resolution_clock::now();
    duration = duration_cast<milliseconds>(stop - start);            
    fout << "QuickSort " << duration.count() / 1000 << " milisecunde " << Test_Sortat(tablou, nr);
    fout << endl;

    // QuickSort cu pivot random

    start = high_resolution_clock::now();
    QuickSortRand(tablou, 0, nr-1);
    stop = high_resolution_clock::now();
    duration = duration_cast<milliseconds>(stop - start);            
    fout << "QuickSortRand " << duration.count() / 1000 << " milisecunde " << Test_Sortat(tablou, nr);
    fout << endl;

    // QuickSort mediana din 3
        
    start = high_resolution_clock::now();
    QuickSortMOT(tablou, 0, nr-1);
    stop = high_resolution_clock::now();
    duration = duration_cast<milliseconds>(stop - start);            
    fout << "QuickSortMOT " << duration.count() / 1000 << " milisecunde " << Test_Sortat(tablou, nr);
    fout << endl;

    return 0;
}
