/**************************************************************************************************
*
*   File name :			graph.t
*
*	Programmer:  		Jeremy Atkins
*
*   Templated implementations of the functions for a graph as defined in graph.h Contains the Graph
*	class, which uses adjacency lists in order to represent an undirected or directed graph, as well
*	as traversal and shortest path functionality
*
*   Date Written:		in the past
*
*   Date Last Revised:	3/14/2019
****************************************************************************************************/
#ifndef GRAPH_T
#define GRAPH_T
#include <iostream>
#include <fstream>
#include <string>
#include <limits.h>
#include <iomanip>
using namespace std;
/*******************************************************************************************
*	Function Name:			Graph()				the constructor
*	Purpose:				This constructor creates a Graph object and initialized a
*							boolean determining whether the graph has data in it or not
*	Input Parameters:		none
*	Return value:			none
********************************************************************************************/
template <class V, class W>
Graph<V, W>::Graph()
{
	populated = false;
}

/*******************************************************************************************
*	Function Name:			~Graph()			the destructor
*	Purpose:				Called upon destruction of the object
*	Input Parameters:		none
*	Return value:			none
********************************************************************************************/
template <class V, class W>
Graph<V, W>::~Graph()
{

}

/*******************************************************************************************
*	Function Name:			isVertex
*	Purpose:				tests whether a vertex is in the graph
*	Input Parameters:		V &v	the vertex to test
*	Return value:			int
********************************************************************************************/
template <class V, class W>
int Graph<V, W>::isVertex(V &v)
{

	for (typename vector<V>::iterator vectIt = G.begin(); vectIt != G.end(); vectIt++)
	{
		if (vectIt->name == v.name)
			return (distance(G.begin(), vectIt));
	}
	return -1;
}

/*******************************************************************************************
*	Function Name:			isUniEdge
*	Purpose:				tests whether a directed edge exists between two vertices
*	Input Parameters:		V &v1	the starting vertex
*							V &v2	the ending vertex
*	Return value:			int
********************************************************************************************/
template <class V, class W>
int Graph<V, W>::isUniEdge(V &v1, V &v2)
{
	int v1Index = isVertex(v1);
	int v2Index = isVertex(v2);
	int firstFound = 0;
	int secondFound = 0;
	if (v1Index == -1 || v1Index == -1)
		return -1;

	//finds one edge
	for (typename list<W>::const_iterator listIt = (G[v2Index].edgelist).begin(); listIt != (G[v2Index].edgelist).end(); listIt++)
	{

		if (listIt->name == v1.name)
			firstFound = 1;
	}

	//finds the other edge
	for (typename list<W>::const_iterator listIt = (G[v1Index].edgelist).begin(); listIt != (G[v1Index].edgelist).end(); listIt++)
	{

		if (listIt->name == v2.name)
			secondFound = 1;
	}

	//returns true only if one or the other was found, false otherwise
	return firstFound ^ secondFound;

}

/*******************************************************************************************
*	Function Name:			isBiDirEdge
*	Purpose:				tests whether an undirected edge exists between two vertices
*	Input Parameters:		V &v1	the starting vertex
*							V &v2	the ending vertex
*	Return value:			int
********************************************************************************************/
template <class V, class W>
int Graph<V, W>::isBiDirEdge(V &v1, V &v2)
{

	int v1Index = isVertex(v1);
	int v2Index = isVertex(v2);
	int firstFound = 0;
	int secondFound = 0;

	if (v1Index == -1 || v2Index == -1)
		return -1;

	//finds one edge
	for (typename list<W>::const_iterator listIt = (G[v2Index].edgelist).begin(); listIt != (G[v2Index].edgelist).end(); listIt++)
	{

		if (listIt->name == v1.name)
			firstFound = 1;
	}

	//finds the other edge
	for (typename list<W>::const_iterator listIt = (G[v1Index].edgelist).begin(); listIt != (G[v1Index].edgelist).end(); listIt++)
	{

		if (listIt->name == v2.name)
			secondFound = 1;
	}

	//returns true if it finds both, false if otherwise
	return (firstFound && secondFound);


}

/*******************************************************************************************
*	Function Name:			AddVertex
*	Purpose:				adds a vertex into the graph
*	Input Parameters:		V &v	the vertex to add
*	Return value:			int
********************************************************************************************/
template <class V, class W>
int Graph<V, W>::AddVertex(V &v)
{
	//if vertex already exists
	if (isVertex(v) != -1)
	{
		cout << "\n\n" << v.name << " already in the graph." << endl;
		return -1;
	}
	else
		G.push_back(v);

	//if nothing in graph
	if (!populated)
		populated = true;

	return 0;
}

/*******************************************************************************************
*	Function Name:			DeleteVertex
*	Purpose:				removes a vertex from the graph
*	Input Parameters:		V &v	the vertex to delete
*	Return value:			int
********************************************************************************************/
template <class V, class W>
int Graph<V, W>::DeleteVertex(V& v)
{
	int vIndex = isVertex(v);

	//if vertex doesn't exist
	if (vIndex == -1)
	{
		cout << "\n\n" << v.name << " not found." << endl;
		return -1;
	}

	//delete vertex
	G.erase(G.begin() + vIndex);

	//delete incident edges
	for (unsigned i = 0; i < G.size(); i++)
	{
		for (typename list<W>::const_iterator listIt = (G[i].edgelist).begin(); listIt != (G[i].edgelist).end(); listIt++)
		{
			if (listIt->name == v.name)
			{
				G[i].edgelist.erase(listIt);
				break;
			}
		}
	}
	return 0;
}

/*******************************************************************************************
*	Function Name:			AddUniEdge
*	Purpose:				adds a directed edge between two nodes
*	Input Parameters:		V &v1	the starting vertex
*							V &v2	the ending vertex
*							W &wt	the edge to add
*	Return value:			int
********************************************************************************************/
template <class V, class W>
int Graph<V, W>::AddUniEdge(V &v1, V &v2, W &wt)
{

	int v1Index = isVertex(v1);
	int v2Index = isVertex(v2);


	//if the vertices don't exist, create them
	if (v1Index == -1)
	{
		AddVertex(v1);
		v1Index = isVertex(v1);
	}
	if (v2Index == -1)
	{
		AddVertex(v2);
		v2Index = isVertex(v2);
	}

	//if updating an old edge, delete it
	if (isUniEdge(v1, v2) == 1)
	{
		cout << "\n\nUnidirectional edge updated" << endl;
		DeleteUniEdge(v1, v2);
	}

	if (isBiDirEdge(v1, v2) == 1)
	{
		cout << "\n\nBidirectional edge updated" << endl;
		DeleteBiDirEdge(v1, v2);
	}

	//add the edge
	wt.name = v2.name;
	G[v1Index].edgelist.push_back(wt);
	return 1;

}


/*******************************************************************************************
*	Function Name:			DeleteUniEdge
*	Purpose:				removes a directed edge between two vertices
*	Input Parameters:		V &v1	the starting vertex
*							V &v2	the ending vertex
*	Return value:			int
********************************************************************************************/
template <class V, class W>
int Graph<V, W>::DeleteUniEdge(V &v1, V &v2)
{
	int v1Index = isVertex(v1);
	int v2Index = isVertex(v2);

	//if vertices are not in graph, return
	if (v1Index == -1)
	{
		cout << "\n\nVertex " << v1.name << " not found." << endl;
		return -1;
	}

	if (v2Index == -1)
	{
		cout << "\n\nVertex " << v2.name << " not found." << endl;
		return -1;
	}

	//if a bidirectional edge is found instead, return
	if (isBiDirEdge(v1, v2) == 1)
	{
		cout << "\n\nBidirectional edge between " << v1.name << " and " << v2.name << ". Delete using the delete bidirectional edge option." << endl;
		return -1;
	}

	//if no edge is found, return
	if (isUniEdge(v1, v2) != 1)
	{
		cout << "\n\nNo edge between " << v1.name << " and " << v2.name << " found." << endl;
		return -1;
	}

	//if the edge is in v2, delete it
	for (typename list<W>::const_iterator listIt = (G[v2Index].edgelist).begin(); listIt != (G[v2Index].edgelist).end(); listIt++)
	{
		if (listIt->name == v1.name)
		{
			G[v2Index].edgelist.erase(listIt);
			return 1;
		}

	}

	//if the edge is in v1, delete it
	for (typename list<W>::const_iterator listIt = (G[v1Index].edgelist).begin(); listIt != (G[v1Index].edgelist).end(); listIt++)
	{
		if (listIt->name == v2.name)
		{
			G[v1Index].edgelist.erase(listIt);
			return 1;
		}

	}

	return 0;

}

/*******************************************************************************************
*	Function Name:			AddBiDirEdge
*	Purpose:				adds an undirected edge between two vertices
*	Input Parameters:		V &v1	first vertex to add edge to
*							V &v2	second vertex to add edge to
*	Return value:			int
********************************************************************************************/
template <class V, class W>
int Graph<V, W>::AddBiDirEdge(V &v1, V &v2, W &wt)
{

	int v1Index = isVertex(v1);
	int v2Index = isVertex(v2);

	//if vertices don't exist, create them
	if (v1Index == -1)
	{
		AddVertex(v1);
		v1Index = isVertex(v1);
	}
	if (v2Index == -1)
	{
		AddVertex(v2);
		v2Index = isVertex(v2);
	}

	//if updating an old edge, delete it
	if (isUniEdge(v1, v2) == 1)
	{
		cout << "\n\nUnidirectional edge updated" << endl;
		DeleteUniEdge(v1, v2);
	}

	if (isBiDirEdge(v1, v2) == 1)
	{
		cout << "\n\nBidirectional edge updated" << endl;
		DeleteBiDirEdge(v1, v2);
	}

	wt.name = v2.name;
	G[v1Index].edgelist.push_back(wt);

	wt.name = v1.name;
	G[v2Index].edgelist.push_back(wt);
	return 1;
	//add edges going both directions
	/*if (AddUniEdge(v1, v2, wt) && AddUniEdge(v2, v1, wt))
		return 1;
	else
		return 0;*/
}

/*******************************************************************************************
*	Function Name:			DeleteBiDirEdge
*	Purpose:				removes an undirected edge from two vertices
*	Input Parameters:		V &v1	the first vertex
*							V &v2	the second vertex
*	Return value:			int
********************************************************************************************/
template <class V, class W>
int Graph<V, W>::DeleteBiDirEdge(V &v1, V &v2)
{
	int v1Index = isVertex(v1);
	int v2Index = isVertex(v2);

	//if vertices not in graph, return
	if (v1Index == -1)
	{
		cout << "\n\nVertex " << G[v1Index].name << " not found." << endl;
		return -1;
	}

	if (v2Index == -1)
	{
		cout << "\n\nVertex " << G[v2Index].name << " not found." << endl;
		return -1;
	}

	//if unidirectional edge is found instead, return
	if (isUniEdge(v1, v2) == 1)
	{
		cout << "\n\nUnidirectional edge found between " << v1.name << " and " << v2.name << ". Delete using the delete unidirectional option." << endl;
		return -1;
	}

	//if no edge is found, return
	if (isBiDirEdge(v1, v2) != 1)
	{
		cout << "\n\nNo bidirectional edge found between " << v1.name << " and " << v2.name << endl;
		return -1;
	}

	//delete from v2
	for (typename list<W>::const_iterator listIt = (G[v2Index].edgelist).begin(); listIt != (G[v2Index].edgelist).end(); listIt++)
	{
		if (listIt->name == v1.name)
		{
			G[v2Index].edgelist.erase(listIt);
			break;
		}

	}

	//delete from v1
	for (typename list<W>::const_iterator listIt = (G[v1Index].edgelist).begin(); listIt != (G[v1Index].edgelist).end(); listIt++)
	{
		if (listIt->name == v2.name)
		{
			G[v1Index].edgelist.erase(listIt);
			break;
		}

	}
	return 1;
}

/*******************************************************************************************
*	Function Name:			SimplePrintGraph
*	Purpose:				prints the graph, performs no specific traversal
*	Input Parameters:		none
*	Return value:			void
********************************************************************************************/
template <class V, class W>
void Graph<V, W>::SimplePrintGraph()
{
	cout << "Printing the graph." << endl;

	for (unsigned i = 0; i < G.size(); i++)
	{
		//print each vertex
		cout << "\n\nVertex: " << G[i].name << endl;

		//if the vertex has no edges, continue
		if (G[i].edgelist.empty())
			cout << "\twith no edges." << endl;

		//otherwise print the edgelist
		for (typename list<W>::const_iterator listIt = (G[i].edgelist).begin(); listIt != (G[i].edgelist).end(); listIt++)
		{
			cout << "\t->(" << listIt->name << " with weight " << listIt->weight << ")" << endl;
		}
		cout << endl;
	}
}

/*******************************************************************************************
*	Function Name:			ShortestDistance
*	Purpose:				Calculates the shortest distance between two vertexes using
*							Dijkstra's algorithm and finds the optimal path between them
*	Input Parameters:		V &v1	the starting vertex
*							V &v2	the ending vertex
*	Return value:			double	the shortest path from v1 to v2
********************************************************************************************/
template <class V, class W>
double Graph<V, W>::ShortestDistance(V &v1, V &v2)
{
	cout << "Calculating the shortest path using Dijkstra's Algorithm." << endl;
	queue<V> q;			//queue used during the calculation
	stack<V> path;		//stack for holding the optimal path

	bool arrow = false;		//used for print formatting
	int v1Index = isVertex(v1);
	int v2Index = isVertex(v2);

	//set minimum distances to infinity, visited to 0, and prev to nothing
	for (unsigned i = 0; i < G.size(); i++)
	{
		G[i].minDist = INT_MAX;
		G[i].visited = 0;
		G[i].prev = "";
	}

	//set starting vertex minimum distance to 0
	G[v1Index].minDist = 0;

	//push start into queue
	q.push(v1);

	while (!q.empty())
	{
		//current vertex to consider
		V curr;
		curr = q.front();

		//remove from queue
		q.pop();
		int currIndex = isVertex(curr);

		//mark current as visited
		G[currIndex].visited = 1;

		//look through edgelist
		for (typename list<W>::const_iterator listIt = (G[currIndex].edgelist).begin(); listIt != (G[currIndex].edgelist).end(); listIt++)
		{
			//look through the vertices
			for (unsigned i = 0; i < G.size(); i++)
			{
				//if a vertex is in the edgelist
				if (listIt->name == G[i].name)
				{
					//get the weight
					int cost = listIt->weight;

					//if the minimum distance plus the weight is less than the minimum distance to the vertices in the edgelist
					if (G[currIndex].minDist + cost < G[i].minDist)
					{
						//push into queue
						q.push(G[i]);

						//set the new minimum distance to the first vertex plus the weight
						G[i].minDist = G[currIndex].minDist + cost;

						//the previous node is now the node just considered
						G[i].prev = G[currIndex].name;
					}
				}
			}
		}
	}

	//if the minimum distance is still infinity, no path exists
	if (G[v2Index].minDist == INT_MAX)
	{
		cout << "\n\nNo path from " << v1.name << " to " << v2.name << " found." << endl;
		return -1;
	}
	
	//printing the path
	V temp;

	//find the previous vertex from the final vertex
	temp.name = G[v2Index].prev;
	temp = G[isVertex(temp)];

	//push the final vertex onto the stack
	path.push(v2);

	//look back at each vertex's previous vertex
	while (temp.prev != "")
	{
		//push previous onto the stack
		path.push(G[isVertex(temp)]);

		//update the temp to be the next previous
		temp.name = temp.prev;
		temp = G[isVertex(temp)];
	}

	//push the origin vertex onto the stack
	path.push(v1);

	cout << "\n\nThe shortest path from " << v1.name << " to " << v2.name << " is: " << endl;

	//pop the stack to get the path from the origin to the final vertex
	while (!path.empty())
	{
		if (!arrow)
		{
			cout << "(" << path.top().name << ")" << endl;
			arrow = true;
		}
		else
			cout << "\t->(" << path.top().name << ")" << endl;
		path.pop();
	}

	return G[v2Index].minDist;
}

/*******************************************************************************************
*	Function Name:			GetGraph
*	Purpose:				reads in a graph from a formatted file
*	Input Parameters:		none
*	Return value:			void
********************************************************************************************/
template <class V, class W>
void Graph<V, W>::GetGraph()
{
	//if the graph has data in it, delete the data
	if (populated)
	{
		for (unsigned i = 0; i < G.size(); i++)
		{
			G[i].edgelist.erase(G[i].edgelist.begin(), G[i].edgelist.end());

		}
		G.erase(G.begin(), G.end());
	}

	//get the filename
	string filename;
	cout << "Enter the filename of the graph:" << endl;
	cin >> filename;
	ifstream inFile;
	inFile.open(filename);
	if (!inFile)
	{
		cout << "\n\nError opening " << filename << endl;
		return;
	}

	//read the data
	V vert;
	W edge;
	int i = 0;

	//read the vertices
	inFile >> vert.name;
	while (inFile)
	{
		vert.visited = 0;

		//push into the vector
		G.push_back(vert);

		//read the edges
		inFile >> edge.name;

		while (edge.name != "#")
		{
			//read the weights and push into the list of the appropriate vertex
			inFile >> edge.weight;
			G[i].edgelist.push_back(edge);
			inFile >> edge.name;
		}
		i++;
		inFile >> vert.name;
	}

	inFile.close();
	cout << "\n\nGraph populated." << endl;
	populated = true;

}

/*******************************************************************************************
*	Function Name:			Breadth First Traversal
*	Purpose:				breadth first traversal of a graph
*	Input Parameters:		V &v	the starting vertex
*	Return value:			void
********************************************************************************************/
template <class V, class W>
void Graph<V, W>::BFTraversal(V &v)
{
	V curr;				//current vertex
	queue<V> q;			//queue used for the traversal
	bool arrow = false;	//used for print formatting

	//if vertex is not in the graph
	int vIndex = isVertex(v);
	if (vIndex == -1)
	{
		cout << "\n\nVertex " << G[vIndex].name << " not found." << endl;
		return;
	}

	//set all of the vertexes to unvisited
	for (unsigned i = 0; i < G.size(); i++)
	{
		G[i].visited = 0;

		//set the current vertex to visited
		if (G[i].name == v.name)
		{
			curr = G[i];
			G[i].visited = 1;
		}
	}

	curr.visited = 1;

	//push start into the queue
	q.push(curr);

	while (!q.empty())
	{
		curr = q.front();

		//print the traversal
		if (!arrow)
		{
			cout << "(" << curr.name << ")" << endl;
			arrow = true;
		}
		else
			cout << "\t->(" << curr.name << ")" << endl;


		q.pop();

		//look through the edgelists
		for (typename list<W>::const_iterator listIt = curr.edgelist.begin(); listIt != curr.edgelist.end(); listIt++)
		{
			for (unsigned i = 0; i < G.size(); i++)
			{
				if (G[i].name == listIt->name)
				{
					//if vertex not visited, mark it visited and push it into the queue
					if (G[i].visited == 0)
					{
						G[i].visited = 1;
						q.push(G[i]);
					}
				}
			}
		}
	}

	//print any vertices unconnected with the starting vertex
	for (unsigned i = 0; i < G.size(); i++)
	{
		if (G[i].visited == 0)
		{
			cout << "\t->(" << G[i].name << ") " << endl;
			G[i].visited = 1;
		}
	}

}

/*******************************************************************************************
*	Function Name:			DFUtility
*	Purpose:				recursive function for the depth first traversal
*	Input Parameters:		V &v	the starting vertex
*	Return value:			void
********************************************************************************************/
template <class V, class W>
void Graph<V, W>::DFUtility(V &v)
{
	static bool arrow = false;	//used for print formatting


	int vIndex = isVertex(v);
	if (G[vIndex].visited == 0)
	{
		//print the vertices
		if (!arrow)
		{
			cout << "(" << G[vIndex].name << ")" << endl;
			arrow = true;
		}
		else
			cout << "\t->(" << G[vIndex].name << ")" << endl;

	}

	//look through the edgelist of v
	for (typename list<W>::const_iterator listIt = (G[vIndex].edgelist).begin(); listIt != (G[vIndex].edgelist).end(); listIt++)
	{
		//if v is not visited, mark it visited
		if (G[vIndex].visited == 0)
		{
			G[vIndex].visited = 1;

			//update v to the next vertex in the edgelist
			v.name = listIt->name;
			v.visited = 1;

			//recursively call this function on the new v
			DFUtility(v);
		}

	}


}

/*******************************************************************************************
*	Function Name:			DFTraversal
*	Purpose:				sets up and calls a depth first traversal using the helper
*							function DFUtility
*	Input Parameters:		V &v	the starting vertex
*	Return value:			void
********************************************************************************************/
template <class V, class W>
void Graph<V, W>::DFTraversal(V &v)
{
	int vIndex = isVertex(v);
	bool arrow = false;

	//if the starting vertex is not found, return
	if (vIndex == -1)
	{
		cout << "\n\nVertex " << v.name << " not found." << endl;
		return;
	}

	//mark all of the vertices as not visited
	for (unsigned i = 0; i < G.size(); i++)
	{
		G[i].visited = 0;
	}

	//call the recursive function
	DFUtility(v);

}

/*******************************************************************************************
*	Function Name:			MST
*	Purpose:				finds the minimum spanning tree of the graph starting at a 
*							specified source vertex
*	Input Parameters:		V &v	the starting vertex
*	Return value:			void
********************************************************************************************/
template <class V, class W>
void Graph<V, W>::MST(V &v)
{
	cout << "Finding the minimum spanning tree using Prim's Algorithm." << endl;

	V selection;		//minimum edge
	queue<V> q;			//queue to check the vertices
	vector<V> t;		//vector of vertices to be considered for the minimum spanning tree
	
	int selIndex;		//the index of the vertex to be put into the minimum spanning tree
	
	//the initial weight of the minimum spanning tree is 0
	double mstCost = 0;

	//set all of the vertices distances to the source vertex and their previous vertex to infinity, previous vertex to the source vertex, and none of them have been checked yet
	for (unsigned i = 0; i < G.size(); i++)
	{
		G[i].component = false;
		G[i].minDist = INT_MAX;
		G[i].prev = v.name;
		G[i].prevDist = INT_MAX;
	}

	//index of the source vertex
	int vIndex = isVertex(v);

	//if the source vertex is not in the graph, return
	if (vIndex == -1)
	{
		cout << "\n\nVertex " << G[vIndex].name << " not found." << endl;
		return;
	}

	//set the source vertex's previous distance to 0, it is being checked so set component to true, and the minimum distance to 0
	G[vIndex].prevDist = 0;
	G[vIndex].component = true;
	G[vIndex].minDist = 0;

	//if the source vertex has no edgelist, there is no way out of that vertex and the minimum spanning tree is just that vertex with weight 0
	if (G[vIndex].edgelist.empty())
	{
		cout << "\n\nNo path exitting " << G[vIndex].name << endl;
		cout << "The weight of the minimum spanning tree starting at: " << G[vIndex].name << " is 0\n\n" << endl;
		return;
	}
	
	//push the source vertex into the queue
	q.push(v);

	//while there are still vertices to check
	while (!q.empty())
	{
		//current vertex
		V curr;

		//set current vertex to the start of the queue
		curr = q.front();

		//remove it from the queue
		q.pop();

		int currIndex = isVertex(curr);

		//look through the current vertex's edgelist
		for (typename list<W>::const_iterator listIt = (G[currIndex].edgelist).begin(); listIt != (G[currIndex].edgelist).end(); listIt++)
		{
			//look through the vertices
			for (unsigned i = 0; i < G.size(); i++)
			{
				//if a vertex is in the edgelist
				if (listIt->name == G[i].name)
				{
					//distance between the current vertex and the vertex in the edgelist
					int cost = listIt->weight;

					//if the minimum distance plus the weight is less than the minimum distance to the vertices in the edgelist
					if (G[currIndex].minDist + cost < G[i].minDist)
					{
						
						//if the vertex has not been checked yet
						if (G[i].component == 0)
						{

							//set the distance to the previous vertex
							G[i].prevDist = cost;

							//set the new minimum distance to the first vertex plus the weight
							G[i].minDist = G[currIndex].minDist + cost;

							//the previous node is now the node just considered
							G[i].prev = G[currIndex].name;

							//push the vertex into the vector for consideration
							t.push_back(G[i]);
						}	
					}
				}
			}
		}

		//if there are no more vertices to check, quit
		if (t.empty())
			break;

		/*for (unsigned i = 0; i < t.size(); i++)
			cout << t[i].name << " ";
		cout << endl;*/

		//find the minimum distance of all of the edges in consideration
		unsigned vecIndex = 0;

		//minimum edge starts at the first edge
		selection = t[vecIndex];
		for (unsigned i = 0; i < t.size(); i++)
		{
			//cout << "\nVertex " << t[i].name << " " << t[i].prevDist << endl;
			
			//if the next edge is smaller than the minumum edge, make that the minimum edge
			if (t[i].prevDist < selection.prevDist)
			{
				vecIndex = i;
				selection = t[vecIndex];
			}
			//cout << "Current selection " << selection.name << " " << selection.prevDist << endl;
			
		}

		//cout << "Selects " << selection.name << " at position " << vecIndex << endl;
		//get the index of the minimum edge
		selIndex = isVertex(selection);

		//that vertex has been considered, so set its component to 1
		G[selIndex].component = 1;
		
		//remove that vertex from consideration
		t.erase(t.begin() + vecIndex);

		//look through the edgelist of the selected minimum vertex
		for (typename list<W>::const_iterator listIt = (G[selIndex].edgelist).begin(); listIt != (G[selIndex].edgelist).end(); listIt++)
		{
			//look through the vertices in consideration
			for (unsigned i = 0; i < t.size(); i++)
			{
				//look through the vertices in the graph
				for (unsigned j = 0; j < G.size(); j++)
				{
					if (listIt->name == G[j].name)
					{
						if (listIt->name == t[i].name)
						{
							//if a smaller weight is found in the graph
							if (listIt->weight < t[i].prevDist && G[j].component == 0)
							{
								//cout << "New weight " << t[i].name << " " << listIt->weight << endl;
								//the new weight of the vertex in consideration is the smaller one found
								t[i].prevDist = listIt->weight;
								G[isVertex(t[i])].prevDist = listIt->weight;
								G[isVertex(t[i])].prev = G[selIndex].name;
							}
						}
					}
				}
			}
		}

		//push the selected vertex into the queue
		q.push(selection);

		//printing out the information for each vertex in each step
		cout << endl;
		for (unsigned i = 0; i < G.size(); i++)
		{
			cout << "Vertex Name:\t" << left << setw(15) << G[i].name;
			if (G[i].prev == "")
				cout << "Previous Node: " << setw(15) << "None";
			else
				cout << "Previous Node: " << setw(15) << G[i].prev;
			if(G[i].prevDist == INT_MAX)
				cout << setw(20) << "Distance from previous:\t" << setw(10) << "INF";
			else
				cout << setw(20) << "Distance from previous:\t" << setw(10) << G[i].prevDist;
			cout << "Components:\t" << G[i].component;
			if (G[i].minDist == INT_MAX)
				cout << "\tDistance from source:\t" << setw(10) << "INF";
			else
				cout << "\tDistance from source:\t" << setw(10) << G[i].minDist;
			cout << endl;
		}
		cout << "--------------------------------------------------------------------------------------------------------------------------------------------------------" << endl;
	}
	
	//sum up the weight of the minimum edges to determine the weight of the minimum spanning tree
	for (unsigned i = 0; i < G.size(); i++)
		mstCost += G[i].prevDist;
	

	
	
	//printing out the minumum spanning tree starting at the source vertex
	int printIndex = vIndex;

	cout << "\n\nThe edges of the minimum spanning tree starting at " << G[vIndex].name << ":" << endl;

	//look through the graph
	for (unsigned i = 1; i <= G.size(); i++)
	{
		//print each vertex in the minimum spanning tree
		cout << "Vertex: " << G[printIndex].name << endl;

		//look through the graph 
		for (unsigned j = 0; j < G.size(); j++)
		{

			//print the previous vertex of each selected vertex as long as the previous vertex is not the same as selected vertex
			if (G[j].prev == G[printIndex].name && G[j].name != G[vIndex].name)
				cout << "\t->(" << G[j].name << " with weight " << G[j].prevDist << ")" << endl;

		}
		cout << endl;
		printIndex = i;
	}
	
	//print out the weight of the minimum spanning tree starting at the source vertex
	cout << "\n\nThe weight of the minimum spanning tree starting at " << G[vIndex].name << " is: " << mstCost << "\n\n" << endl;
}

/*******************************************************************************************
*	Function Name:			FordShortestPath
*	Purpose:				Calculates the shortest distance between all of the vertices
*							in the graph using Ford's algorithm to handle negative
*							edge weights
*	Input Parameters:		V &v	the starting vertex
*	Return value:			none
********************************************************************************************/
template <class V, class W>
void Graph<V, W>::FordShortestPath(V &v1)
{
	deque<V> q;			//queue used during the calculation
	stack<V> path;		//stack for holding the optimal path
	deque<V> dq;
	int iterations = 0;

	bool arrow = false;		//used for print formatting
	int v1Index = isVertex(v1);
	

	int cost;			//weight

	//set minimum distances to infinity, visited to 0, and prev to nothing
	for (unsigned i = 0; i < G.size(); i++)
	{
		G[i].minDist = INT_MAX;
		G[i].visited = 0;
		G[i].prev = "";
	}

	//set starting vertex minimum distance to 0
	G[v1Index].minDist = 0;

	//push start into queue
	q.push_front(v1);

	while (!q.empty())
	{
		//current vertex to consider
		V curr;
		cout << "\n\nIteration " << iterations << endl;
		iterations++;
		curr = q.front();
		cout << curr.name << " added to the queue." << endl;
		//remove from queue
		cout << curr.name << " popped from the queue." << endl;
		q.pop_front();
		int currIndex = isVertex(curr);

		//mark current as visited
		G[currIndex].visited = 1;

		//look through edgelist
		for (typename list<W>::const_iterator listIt = (G[currIndex].edgelist).begin(); listIt != (G[currIndex].edgelist).end(); listIt++)
		{
			//look through the vertices
			for (unsigned i = 0; i < G.size(); i++)
			{
				//if a vertex is in the edgelist
				if (listIt->name == G[i].name)
				{
					//get the weight
					cost = listIt->weight;

					//if the current minimum distance plus the cost is less than the minimum distances in the edgelist
					if (G[currIndex].minDist + cost < G[i].minDist)
					{
						
						//the minimum distance of the edge is the current minimum distance plus the cost
						G[i].minDist = G[currIndex].minDist + cost;

						//the vertex in the edgelist's previous vertex is the current vertex
						G[i].prev = G[currIndex].name;

						//if the vertex in the edgelist has not been visited, push it into the queue
						if (G[i].visited == 0)
						{
							cout << G[i].name << " added to the queue." << endl;
							q.push_front(G[i]);
						}
						
					}
				}
			}
		}
	}

	//set the source vertex previous and minimum distance
	G[v1Index].prev = "";
	G[v1Index].minDist = 0;

	//print the distances from the source
	cout << "\n\nThe distances from the source " << G[v1Index].name << endl;
	for (unsigned i = 0; i < G.size(); i++)
	{
		//if there is no path to a vertex, the distance is infinite
		if (G[i].minDist == INT_MAX)
		{
			cout << "Vertex Name: " << G[i].name << " Distance: INF" << endl;
			break;
		}
		
		//print the connected vertices, their minimum distances, and their previous vertice
		cout << "Vertex Name: " << G[i].name << "\tDistance: " << G[i].minDist << "\tPrevious Vertex: ";
		if (G[i].prev == "")
			cout << "None" << endl;
		else
			cout << G[i].prev << endl;
	}
}

#endif // !GRAPH_T

