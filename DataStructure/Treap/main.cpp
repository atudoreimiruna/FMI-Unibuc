#include <iostream>
#include <cstdlib>

using namespace std;

// structura treap-ului
struct Treap
{
    int cheie, prioritate;
    Treap *stanga, *dreapta;
};

// CAUTARE
Treap* Cautare(Treap* treap, int cheie)
{
    // Daca treap-ul este null sau cheia este in radacina 
    if ( treap == NULL || treap->cheie == cheie)
        return treap;
    
    // daca cheia este mai mare decat cheia radacinii, se va face cautarea in dreapta
    if ( treap->cheie < cheie )
        return Cautare(treap->dreapta, cheie);

    // daca cheia este mai mica decat cheia radacinii, se va face cautarea in stanga
    return Cautare(treap->stanga, cheie);
}

Treap* NodNou(int cheie)
{
    Treap* nou = new Treap;
    nou->cheie = cheie;
    nou->prioritate = rand()%100;   // valori intre 0 si 99
    nou->stanga = nou->dreapta = NULL;
    return nou;
}

Treap* RotireLaDreapta(Treap* t2)
{
    Treap *t1 = t2->stanga;
    Treap *t = t1->dreapta;

    /// Realizeaza rotatia
    t1->dreapta = t2;
    t2->stanga = t;

    /// Returneaza noul treap
    return t1;
}

Treap* RotireLaStanga(Treap* t1)
{
    Treap *t2 = t1->dreapta;
    Treap *t = t2->stanga;

    /// Rotatia
    t2->stanga = t1;
    t1->dreapta = t;

    /// Returneaza noul treap
    return t2;
}

// INSERARE
Treap* Inserare(Treap* treap, int cheie)
{
    // Daca treap-ul este null, cream un nou nod
    if ( !treap )
        return NodNou(cheie);

    // Daca cheia este mai mica decat cheia radacinii
    if ( cheie <= treap->cheie )
    {
        // inserez in subarborele din stanga
        treap->stanga = Inserare(treap->stanga, cheie);

        if ( treap->stanga->prioritate > treap->prioritate )
            treap = RotireLaDreapta(treap);
    }
    else
    // Daca cheia este mai mare decat cheia radacinii
    {
        // inserez in subarborele din dreapta
        treap->dreapta = Inserare(treap->dreapta, cheie);

        if ( treap->dreapta->prioritate > treap->prioritate)
            treap = RotireLaStanga(treap);
    }
    return treap;
}

// STERGERE
Treap* Stergere(Treap* treap, int cheie)
{
    if ( !treap )
        return treap;
    
    if ( cheie < treap->cheie )
        treap->stanga = Stergere(treap->stanga, cheie);
    else 
        if ( cheie > treap->cheie )
            treap->dreapta = Stergere(treap->dreapta, cheie);
        else
            if ( treap->stanga == NULL )
            {
                Treap *nou = treap->dreapta;
                delete(treap);
                treap = nou;    // copilul din dreapta va fi radacina
            }
            else
                if ( treap->dreapta == NULL )
                {
                    Treap *nou2 = treap->stanga;
                    delete(treap);
                    treap = nou2;   // copilul din stanga va fi radacina
                }
                else
                    // daca cheia este in radacina si dreapta si stanga nu sunt nule
                    if ( treap->stanga->prioritate < treap->dreapta->prioritate )
                    {
                        treap = RotireLaStanga(treap);
                        treap->stanga = Stergere(treap->stanga, cheie);
                    }
                    else
                    {
                        treap = RotireLaDreapta(treap);
                        treap->dreapta = Stergere(treap->dreapta, cheie);
                    }
    return treap;
}

int ValoareMaxima(Treap* treap)
{
    if ( treap == NULL )
        return 0;

    // Vom returna maximul dintre 3 valori:
    // cheia radacinii
    // maximul subarborelui din stanga
    // si maximul subarborelui din dreapta
    int max1 = treap->cheie;
    int max2 = ValoareMaxima(treap->stanga);
    int max3 = ValoareMaxima(treap->dreapta);

    if ( max2 > max1 )
        max1 = max2;
    if ( max3 > max1 )
        max1 = max3;
    return max1;
}

// SUCCESOR
void Succesor(Treap* treap, Treap*& succesor, int cheie)
{
    if ( treap == NULL || ValoareMaxima(treap) <= cheie )  
        return ;

    // Daca cheia se afla in radacina
    if ( treap->cheie == cheie )
    {
        if ( treap->dreapta != NULL )
        {
            Treap* nou = treap->dreapta ;
            while ( nou->stanga )
                nou = nou->stanga ;
            succesor = nou ;
        }
        return ;
    }

    if ( treap->cheie > cheie )
    {
        succesor = treap ;
        Succesor(treap->stanga,succesor,cheie) ;
    }
    else
    {
        Succesor(treap->dreapta,succesor,cheie) ;
    }
}

int ValoareMinima(Treap* treap)
{
    if ( treap == NULL )
        return 0;
    
    Treap* copie = treap;

    // Cautam frunza cea mai din stanga
    while ( copie->stanga != NULL )
    {
        copie = copie->stanga;
    }
    return copie->cheie;
}

// PREDECESOR
void Predecesor(Treap* treap, Treap*& predecesor, int cheie)
{
    if (treap == NULL || ValoareMinima(treap) >= cheie )  
        return ;

    // Daca cheia se afla in radacina
    if ( treap->cheie == cheie )
    {
        //Valoarea maxima din subarborele din stanga este predecesor
        if ( treap->stanga != NULL )
        {
            Treap* nou = treap->stanga;
            while ( nou->dreapta )
                nou = nou->dreapta;
            predecesor = nou ;
        }
        return;
    }

    // Daca cheia din radacina este mai mare decat cheia introdusa, cautam in subarborele din dreapta
    if ( treap->cheie > cheie )
    {
        Predecesor( treap->stanga,predecesor,cheie) ;
    }
    else
    {
        predecesor = treap;
        Predecesor(treap->dreapta,predecesor,cheie) ;
    }
}

// AFISARE ELEMENTE SORTATE
void AfisareCrescator(Treap* treap)
{
    if ( treap == NULL )
        return;
    if ( treap != NULL )
    {
        AfisareCrescator(treap->stanga);
        cout << treap->cheie << " ";
        AfisareCrescator(treap->dreapta);
    }
}

void AfisareTreap(Treap* treap)
{
    if ( treap )
    {
        AfisareTreap(treap->stanga);
        cout << "cheie: " << treap->cheie << " / prioritate: " << treap->prioritate;
        if ( treap->stanga )
            cout << " / copilul din stanga: " << treap->stanga->cheie;
        if ( treap->dreapta )
            cout << " / copilul din dreapta: " << treap->dreapta->cheie;
        cout << "\n";
        AfisareTreap(treap->dreapta);
    }
}

int main()
{
    int cerinta, valoare;
    struct Treap *treap = NULL;
    bool gasit = false;
    while ( 1 )
    {
        gasit = false;
        cout << "1. Inserare element " << "\n";
        cout << "2. Stergere element " << "\n";
        cout << "3. Afisare succesor" << "\n";
        cout << "4. Afisare predecesor" << "\n";
        cout << "5. Afisare in ordine crescatoare" << "\n";
        cout << "6. Iesire" << "\n";

        cout << "Introduceti cerinta: ";
        cin >> cerinta;
        cout << "\n";

        switch(cerinta)
        {
            case 1:
                {
                    cout << "Introduceti valoarea care trebuie inserata: ";
                    cin >> valoare;
                    treap = Inserare(treap, valoare);
                    break;
                }
            case 2:
                {
                    if ( treap == NULL )
                    {
                        cout << "Treap-ul este gol" << "\n";
                        continue;
                    }
                    cout << "Introduceti elementul pe care vreti sa-l stergeti: ";
                    cin >> valoare;
                    Treap *cauta = Cautare(treap, valoare);
                    if ( cauta != NULL )
                        gasit = true;
                    else 
                        cout << "Elementul nu se afla in treap!" << "\n";
                    treap = Stergere(treap, valoare);
                    if ( cauta != NULL && gasit )
                        cout << "Elementul a fost sters din treap!" << "\n";
                    break;
                }
            case 3:
                {
                    Treap* succesor = NULL;
                    int val;
                    cout << "Introduceti valoarea pentru care doriti sa gasiti succesorul: ";
                    cin >> val;
                    Succesor(treap, succesor, val);
                    if ( succesor == NULL )
                        cout << "Nu exista un succesor pentru valoarea citita!" << "\n";
                    else
                    {
                        cout << "Succesorul valorii citite este: " << succesor->cheie << "\n";
                    }
                }
            case 4:
                {
                    Treap* predecesor=NULL;
                    int val;
                    cout << "Introduceti valoarea pentru care vreti sa gasiti un predecesor: ";
                    cin>>val;
                    Predecesor(treap, predecesor, val);
                    if ( predecesor == NULL )
                        cout << "Nu exista un predecesor pentru valoarea citita!" << "\n";
                    else
                    {
                        cout << "Predecesorul valorii citite este: " << predecesor->cheie << "\n";
                    }
                    break;
                }
            case 5:
                {
                    if ( treap == NULL )
                    {
                        cout << "Treap-ul este gol" << "\n";
                        continue;
                    }
                    cout << "Afiseaza elementele in ordine crescatoare :" << "\n";
                    AfisareCrescator(treap);
                    cout << "\n";
                    break;
                }
            case 6:
                {
                    exit(1);
                    break;
                }
            default:
                cout << "Alegere gresita" << "\n";
        }
    }
    return 0;
}
