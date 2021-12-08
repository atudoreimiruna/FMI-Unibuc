#include <iostream>
#include <fstream>
#include <vector>
#include <stack>
#include <algorithm>
#include <queue>

#define inf 1000000000
#define Max 100001
#define Max2 50005

using namespace std;

ifstream fin("clasa_graf.in");
ofstream fout("clasa_graf.out");

int number_of_problem;

int N, M, S;
bool visited[Max];
int Stack[Max], top;

int up[Max], levels[Max];
vector<int> biconnected_components[Max];
int number_of_biconnected_components;

vector<int> scc[Max];   // strongly connected components
bool visitedDFS[Max], visitedDFSt[Max];   // pentru DFS pe grafurile initial si transpus
vector<int> transpose_graph[Max];

int topological_sort[Max], nr;

vector<int> values;

struct elem
{
    int x, y, c;
};
elem WeightedGraph[4*Max];

pair <int,int> APM[200002];
int parentAPM[2*Max], degree[2*Max];

int parent[Max], height[Max];

int D[Max2]; // D[i] – distanta minima intre nodul de start si nodul numarul i
 
vector <pair<int,int> >weighted_graph[Max2];
priority_queue <pair<int,int> >q;

queue <int> Queue;
bool queue_check[Max2];

int matrix[105][105];

class Graph{
private:
    int NumberOfNodes, NumberOfEdges;
    vector<int> adjacencyList[Max];
    
public:
    Graph(int N, int M); // constructor

    // citiri
    void Read_DirectedGraph();
    void Read_UndirectedGraph();

    // TEMA 1

    // BFS -- 1
    void BFS(int Start_Node);

    // DFS ( numar componente conexe ) -- 2
    void DFS(int Start_Node, bool visited[]);
    int NumberOfConnectedComponents();

    // Biconex -- 3
    void DFS_BiconnectedComponents(int node, int parent, bool visited[], int up[], int levels[]);
    void Write_BiconnectedComponents();

    // Componente tare conexe -- 4
    void Read_Directed_Transpose_Graph();
    void DFS(int nod);
    void DFS_transpose(int node, int ct);
    void SCC();
    void Transpose_Graph();
    void Crossing();

    // Sortare topologica -- 5
    void DFS_topological_sort(int node);
    void TopologicalSort();

    // Hakimi -- 6
    bool Hakimi(vector<int> values, int Nr_Noduri);

    // TEMA 2

    // APM - Kruskal -- 7
    void Read_Directed_Weighted_Graph();
    void Kruskal();

    // Disjoint -- 8
    int Find_Root(int node);
    void Union_Root(int node1, int node2);
    void Disjoint();

    // Dijkstra -- 9
    void Read_Dijkstra();
    void Dijkstra( int node );
    void Write_Dijkstra();

    // Bellman-Ford -- 10
    void Read_BellmanFord();
    bool BellmanFord( int node );
    void Write_BellmanFord();

    // TEMA 3

    // Roy-Floyd
    void RoyFloyd(int matrix[105][105]);

    // Diametru arbore
    void BFS_Darb(int Start_node, int &max_diameter, int &next_node);
    void Darb();
};

// constructor
Graph :: Graph(int N, int M)
{
    NumberOfNodes = N;
    NumberOfEdges = M;
}


// citiri

void Graph :: Read_DirectedGraph()
{
    for ( int i = 1; i <= NumberOfEdges; i++ )
    {
        int x, y;
        fin >> x >> y;
        adjacencyList[x].push_back(y);
    }
}

void Graph :: Read_UndirectedGraph()
{
    for ( int i = 1; i <= NumberOfEdges; i++ )
    {
        int x, y;
        fin >> x >> y;
        adjacencyList[x].push_back(y);
        adjacencyList[y].push_back(x);
    }
}

// BFS

void Graph :: BFS(int Start_Node)
{
    bool visited[Max] = {0};
    queue <int> Q;
    int cost[Max] = {0};
    int x;

    // inserez nodul de start in coada vida, iar acesta va avea costul 0
    // cost[nod_Start] = 0;
    visited[Start_Node] = 1;
    Q.push(Start_Node);

    while ( !Q.empty() )    // cat timp coada nu este vida
    {
        // la fiecare pas luam nodul din inceputul cozii, dupa care il vom elimina
        x = Q.front();
        Q.pop();

        for ( int i = 0; i < adjacencyList[x].size(); i++ )
            if ( visited[adjacencyList[x][i]] == 0 )    // daca i este vecin cu nodul curent si nu este vizitat
            {
                Q.push(adjacencyList[x][i]);
                // costul unui nod nou adaugat va fi costul nodului care l-a adaugat + 1.
                cost[adjacencyList[x][i]] = cost[x] + 1;
                visited[adjacencyList[x][i]] = 1;
            }
    }
    // afisare costuri
    for ( int i = 1; i <= NumberOfNodes; i++ )
        if ( visited[i] != 0 )
            fout << cost[i] << " ";
        else 
            fout << -1 << " ";  // daca nu se poate ajunge din nodul S la nodul i, atunci numarul corespunzator numarului i va fi -1
}

// DFS ( componente conexe )

void Graph :: DFS(int Start_Node, bool visited[])
{
    visited[Start_Node] = 1;    // se viziteaza nodul de start
    // cautam primul vecin nevizitat al nodului de start
    // continuam parcurgerea pana cand toate varfurile accesibile 
    // din varful de start sunt vizitate
    for ( int i = 0; i < adjacencyList[Start_Node].size(); i++ )
        if ( visited[adjacencyList[Start_Node][i]] == 0 )
            DFS(adjacencyList[Start_Node][i], visited);
}

int Graph :: NumberOfConnectedComponents()
{
    bool visited[NumberOfNodes];
    for ( int i = 0; i < NumberOfNodes; i++ )
        visited[i] = 0;

    int number_of_connected_components = 0;
    for ( int i = 1; i <= NumberOfNodes; i++ )
        if ( !visited[i] )  // daca varful curent nu este vizitat
        {
            // avem o componenta conexa
            // parcurgem graful pornind din nodul curent si marcam in vectorul vizitat varfurile parcurse
            number_of_connected_components++;
            DFS(i, visited);
        }
    return number_of_connected_components;
}

// Biconex 

void Graph :: DFS_BiconnectedComponents(int node, int parent, bool visited[], int up[], int levels[])
{
    visited[node] = 1;
    up[node] = levels[node];
    Stack[++top] = node; // adaugam nodul in stiva

    for ( auto i : adjacencyList[node] )
    {
        if ( i == parent ) continue;
        if ( visited[i] )
            up[node] = min(up[node], levels[i]);
        else
        {
            levels[i] = levels[node] + 1;
            DFS_BiconnectedComponents(i, node, visited, up, levels);
            if ( up[i] >= levels[node] )
            {
                number_of_biconnected_components++;
                while ( top && Stack[top] != i )
                    biconnected_components[number_of_biconnected_components].push_back(Stack[top--]);
                biconnected_components[number_of_biconnected_components].push_back(Stack[top--]);
                biconnected_components[number_of_biconnected_components].push_back(node);
            }
            up[node] = min(up[node], up[i]);
        }
    }
}

void Graph :: Write_BiconnectedComponents()
{
    int j;
    fout << number_of_biconnected_components << "\n";
    for ( int i = 1; i <= number_of_biconnected_components; i++ )
    {
        for ( auto j : biconnected_components[i] )
            fout << j << " ";
        fout << "\n";
    }
}

// Componente Tare Conexe

void Graph :: Read_Directed_Transpose_Graph()
{
    for ( int i = 1; i <= NumberOfEdges; i++ )
    {
        int x, y;
        fin >> x >> y;
        adjacencyList[x].push_back(y);
        transpose_graph[y].push_back(x);
    }
}
 
void Graph :: DFS(int node)
{
    visitedDFS[node] = 1;
 
    for ( auto i : adjacencyList[node] )
        if ( !visitedDFS[i] )
            DFS(i);
 
    // pentru nodul x putem stabili timpul de finalizare si il memoram in stiva
    Stack[++top] = node;    
}
 
// stabilim timpul de finalizare pentru fiecare nod
void Graph :: Crossing()   // cel initial
{
    for ( int i = 1; i <= NumberOfNodes; i++ )
        if ( ! visitedDFS[i] )
            DFS(i);
}
 
void Graph :: DFS_transpose(int node, int ct)
{
    visitedDFSt[node] = 1;
    scc[ct].push_back(node);
 
    for ( auto i : transpose_graph[node] )
        if ( !visitedDFSt[i] )
            DFS_transpose(i, ct);
}
 
void Graph :: SCC()
{
    int ct_comp = 0;
 
    while( top )
    {
        // parcurgem in adancime graful transpus
        // consideram nodurile in ordinea descrescatoare timpilor de finalizare
        if( !visitedDFSt[Stack[top]] )
        {
            ct_comp ++;
            DFS_transpose(Stack[top], ct_comp);  // DFS in graful transpus
        }
        top--;
    }
 
    fout << ct_comp << "\n";
 
    for ( int i = 1; i <= ct_comp; i++ )
    {
        for( auto j : scc[i] )
                fout << j << " ";
        fout << "\n";
    }
}

// Sortare topologica

void Graph :: DFS_topological_sort(int node)
{
    visited[node] = 1;

    for ( auto i : adjacencyList[node] )
        if ( visited[i] == 0 )
            DFS_topological_sort(i);

    topological_sort[++nr] = node;    
}

void Graph :: TopologicalSort()
{
    // realizam o parcurgere în adancime si 
    // calculăm timpii finali pentru fiecare nod 
    for ( int i = 1; i <= NumberOfNodes; i++ )
        if ( visited[i] == 0 ) DFS_topological_sort(i);
    for ( int i = NumberOfNodes; i >= 1; i-- )
        fout << topological_sort[i] << " ";
    fout << "\n";
}

// Hakimi

bool Graph :: Hakimi(vector<int> values, int NumberOfNodes)
{
    bool ok = 1;
    while ( ok )
    {
        // sortam vectorul de valori descrescator
        sort ( values.begin(), values.end(), greater<int>() );

        // daca cea mai mare valoare este mai mare decat numarul de elemente a vectorului
        if ( values[0] > values.size() - 1 ) return 0;

        // daca cea mai mare valoare din vector este 0 inseamna ca tot vectorul este format din elemente egale cu 0
        if ( values[0] == 0 ) return 1;

        values.erase( values.begin() + 0 ); // stergem elementul cel mai mare
    
        for ( int i = 0; i < values[0]; i++ )
        {
            values[i]--;
            if ( values[i] < 0 ) return 0;
        }
    }
}

// APM - Kruskal

inline bool cmp(const elem &a, const elem &b)
{
    return a.c < b.c;
}
 
void Graph :: Read_Directed_Weighted_Graph()
{
    for ( int i = 1; i <= NumberOfEdges; i++ )
    {
        fin >> WeightedGraph[i].x;
        fin >> WeightedGraph[i].y;
        fin >> WeightedGraph[i].c;
    }
    // se ordoneaza muchiile grafului crescator dupa cost
    sort(WeightedGraph+1, WeightedGraph+NumberOfEdges+1, cmp);
}
 
// functie care verifica tatal unui nod
int Check_Parent(int node)
{
    // aceasta cautare se termina cand tatal nodului curent este nodul curent
    while ( parentAPM[node] != node )
        node = parentAPM[node];
    return node;
}

void Connection(int x, int y)
{
    x = Check_Parent(x);
    y = Check_Parent(y);
    // unim nodurile in functie de rangul acestora
    // intotdeauna legam subarborele mai mic de cel mai mare
    if ( degree[x] < degree[y] )
        degree[x] = y;

    if ( degree[x] > degree[y] )
        degree[y] = x;

    if ( degree[x] == degree[y] )
    {
        degree[x] = y;
        degree[y]++; 
    }
}

void Graph :: Kruskal()
{
    int S = 0;
    int k = 0;
    // pentru fiecare nod din graf vom memora reprezentantul sau 
    // (de fapt al subarborelui din care face parte)
    // folosim tabloul unidimensional tata
    for ( int i = 1; i <= NumberOfNodes; i++ )
    {
        parentAPM[i] = i;
        degree[i] = 1;
    }
 
    // determinare APM
    for ( int i = 1; i < NumberOfEdges; i++ )
    {
        // daca extremitatile muchiei fac parte din subarbori diferiti,
        // acestia se vor reuni, iar muchia respectiva face parte din APM
        if ( Check_Parent(WeightedGraph[i].x) != Check_Parent(WeightedGraph[i].y) )
        {
            Connection(Check_Parent(WeightedGraph[i].x), Check_Parent(WeightedGraph[i].y) );

            APM[++k].first = WeightedGraph[i].x;
            APM[k].second = WeightedGraph[i].y;
            // adunam costul total al arborelui 
            S += WeightedGraph[i].c;
        }
    }
 
    // afisare
    fout << S << '\n' << NumberOfNodes-1 << '\n';
    for ( int i = 1; i <= k; i++ )
        fout << APM[i].first << " " << APM[i].second << '\n';
}

// Disjoint

// gaseste radacina arborelui la care apartine nodul
int Graph :: Find_Root(int node)
{
    if ( node != parent[node] )
    {
        parent[node] = Find_Root(parent[node]);
        return parent[node];
    }
    return node;
}
 
void Graph :: Union_Root(int node1, int node2)
{
    int root_node1 = Find_Root(node1);
    int root_node2 = Find_Root(node2);
 
    if ( root_node1 != root_node2 )
    {
        if ( height[root_node1] > height[root_node2] )
            parent[root_node2] = root_node1;
        else
        {
            parent[root_node1] = root_node2;
            if ( height[root_node1] == height[root_node2] )
                height[root_node2] ++;
        }
    }
}
 
void Graph :: Disjoint()
{
    for ( int i = 1; i <= NumberOfNodes; i++ ) // fiecare nod este propriul sau parinte
        parent[i] = i;
 
    for ( int i = 1; i <= NumberOfEdges; i++ )
    {
        int op, x, y;
        fin >> op >> x >> y;
 
        if ( op == 1 ) // reunim multimile nodurilor x si y
            Union_Root(x,y);
        else
        {
            int a = Find_Root(x);  // daca nodurile x si y au aceeasi radacina atunci sunt din aceeasi multime
            int b = Find_Root(y);
            if ( a == b )
                fout << "DA\n";
            else
                fout << "NU\n";
        }
    }
}

// Dijkstra

void Graph :: Read_Dijkstra()
{
    for ( int i = 1; i <= NumberOfEdges; i++ )
    {
        int x, y, cost;
        fin >> x >> y >> cost;
        weighted_graph[x].push_back(make_pair(cost, y));
    }
 
    // setam vectorul pe inf
    for ( int i = 1; i <= NumberOfNodes; i++ )
        D[i] = inf;
}
 
void Graph :: Dijkstra(int Start_node)
{   
    // distanta pana la nodul de start = 0
    D[Start_node] = 0;
 
    // Punem nodul de start in coada
    q.push(make_pair(0,Start_node));
    queue_check[Start_node] = 1;
 
    while ( !q.empty() )
    {
        // extragem nodul curent
        int node = q.top().second;
        q.pop();
 
        queue_check[node] = 0;
        for ( auto i : weighted_graph[node] )
        {
            int next = i.second;    // vecinul
            int cost = i.first;
            // daca gasim o distanta mai mica
            if ( D[node] + cost < D[next] )
            {
                D[next] = D[node] + cost;
                // daca vecinul nu se afla in coada il adaugam
                if ( queue_check[next] == 0 )
                {
                    queue_check[next] = 1;
                    q.push(make_pair(D[next],next));
                }
            }
        }
    }
}
 
void Graph :: Write_Dijkstra()
{
    for ( int i = 2; i <= NumberOfNodes; i++ )
    {
        if ( D[i] != inf )
            fout << D[i] << " ";
        else 
            fout << "0 ";
    }
}

// Bellman-Ford

void Graph :: Read_BellmanFord()
{
    for ( int i = 1; i <= NumberOfEdges; i++ )
    {
        int x, y, cost;
        fin >> x >> y >> cost;
        weighted_graph[x].push_back(make_pair(y, cost));
    }
 
    // initializari
    for ( int i = 1; i <= NumberOfNodes; i++ )
    {
        visited[i] = 0;
        D[i] = inf;
        queue_check[i] = 0;
    }  
}
 
bool Graph :: BellmanFord(int Start_node)
{   
    // distanta pana la nodul de start = 0
    D[Start_node] = 0;
 
    // Punem nodul de start in coada
    Queue.push(Start_node);
    queue_check[Start_node] = 1;
 
    while ( !Queue.empty() )
    {
        // extragem nodul curent
        int node = Queue.front();
        Queue.pop();
        visited[node]++;
        if ( visited[node] >= NumberOfNodes )
            return 0;
        
        queue_check[node] = 0;
        for ( size_t i = 0; i < weighted_graph[node].size(); i++ )
        {
            int next = weighted_graph[node][i].first; // vecin
            int cost = weighted_graph[node][i].second;
            // daca gasim o distanta mai mica
            if ( D[node] + cost < D[next] )
            {
                D[next] = D[node] + cost;
                // daca vecinul nu se afla in coada il adaugam
                if ( ! queue_check[next] )
                    Queue.push(next);
                
            }
        }
    }
    return 1;
}
 
void Graph :: Write_BellmanFord()
{
    if ( BellmanFord(1) )
    {
        for ( int i = 2; i <= NumberOfNodes; i++ )
            fout << D[i] << " ";
    }
    else
        fout << "Ciclu negativ!";
}

// Roy-Floyd

void Graph :: RoyFloyd(int matrix[105][105])
{
    // citire si initializare 
    for ( int i = 1; i <= N; i++ )
        for ( int j = 1; j <= N; j++ )
            fin >> matrix[i][j];

    for ( int i = 1; i <= N; i++ )
        for ( int j = 1; j <= N; j++ )
            if ( i == j )   matrix[i][j] = 0;
            else 
                if ( matrix[i][j] == 0 && i != j)
                    matrix[i][j] = inf;

    // Roy-Floyd
    for ( int k = 1; k <= N; k++ )
        for ( int i = 1; i <= N; i++ )
            for ( int j = 1; j <= N; j++ )
                if ( matrix[i][j] > matrix[i][k] + matrix[k][j] )
                    matrix[i][j] = matrix[i][k] + matrix[k][j];

    // afisare
    for ( int i = 1; i <= N; i++ )
        for ( int j = 1; j <= N; j++ )
            if ( matrix[i][j] == inf ) matrix[i][j] = 0;

    for ( int i = 1; i <= N; i++ )
    {
        for ( int j = 1; j <= N; j++ )
            fout << matrix[i][j] << " ";
            fout<<"\n";
    }
}

// Diametru arbore
void Graph :: BFS_Darb(int Start_node, int &max_diameter, int &next_node)
{
    int d[Max];
    bool visited[Max] = {0};
    queue<int> q;
    
    visited[Start_node] = 1;
    q.push(Start_node);
    d[Start_node] = 1;

    while ( !q.empty() )
    {
        int node = q.front();
        for ( auto i : adjacencyList[node] )
            if ( !visited[i] )
            {
                visited[i] = 1;
                q.push(i);
                d[i] = d[node] + 1;
            }
        q.pop();
    }

    max_diameter = 0;
    for ( int i = 1; i <= NumberOfNodes; i++ )
        if ( d[i] > max_diameter )
        {
            max_diameter = d[i];
            next_node = i;
        }
}

void Graph :: Darb()
{
    int first, next, max_diameter;
    BFS_Darb(1, max_diameter, first);
    BFS_Darb(first, max_diameter, next);
    fout << max_diameter;
}

int main()
{
    fin >> number_of_problem;

    fin >> N >> M;
    Graph G(N, M);

    if ( number_of_problem == 1 )
    {
        // BFS
        fin >> S;
        G.Read_DirectedGraph();
        G.BFS(S);
    }
    
    if ( number_of_problem == 2 )
    {
        // DFS
        G.Read_UndirectedGraph();
        fout << G.NumberOfConnectedComponents();
    }
        
    if ( number_of_problem == 3 )
    {
        // Biconex
        G.Read_UndirectedGraph();
        G.DFS_BiconnectedComponents(1, 0, visited, up, levels);
        G.Write_BiconnectedComponents();
    }
         
    if ( number_of_problem == 4 )
    {
        // Componente Tare Conexe
        G.Read_Directed_Transpose_Graph();
        G.Crossing();
        G.SCC();
    }
  
    if ( number_of_problem == 5 )
    {
        // Sortare Topologica
        G.Read_DirectedGraph();
        G.TopologicalSort();
    }
                    
    if ( number_of_problem == 6 )
    {
        // Hakimi
        int x;
        for ( int i = 1; i <= N; i++ )
        {
            fin >> x;
            values.push_back(x);
        }
    
        if ( G.Hakimi ( values, N ) ) 
            fout<< "DA";    
        else 
            fout << "NU";
    }
                        
    if ( number_of_problem == 7 )
    {
        // APM - Kruskal
        G.Read_Directed_Weighted_Graph();
        G.Kruskal();
    }
                            
    if ( number_of_problem == 8 )
    {
        // Disjoint
        G.Disjoint();
    }
                                 
    if ( number_of_problem == 9 )
    {
        // Dijkstra
        G.Read_Dijkstra();
        G.Dijkstra(1);
        G.Write_Dijkstra();
    }
                                       
    if ( number_of_problem == 10 )
    {
        // Bellman Ford
        G.Read_BellmanFord();
        G.Write_BellmanFord();
    }
                    
    if ( number_of_problem == 11 )
    {
        // Roy-Floyd
        G.RoyFloyd(matrix);
    }

    if ( number_of_problem == 12 )
    {
        // Diametru Arbore
        Graph G1(N, N-1);
        G1.Read_UndirectedGraph();
        G1.Darb();
    }
    
    return 0;
}