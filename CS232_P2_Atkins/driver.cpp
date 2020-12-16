/**************************************************************************************************
*
*   File name :			driver.cpp
*
*	Programmer:  		Jeremy Atkins
*
*   Driver file initializing a Maze object and setting up a menu allowing the user to manipulate
*	the graph by adding and removing vertices and edges, as well as printing the graph either
*	simply, breadth first, or depth first. Also includes the ability to find the shortest
*	path between two nodes using Dijkstra's algorithm, as well as functions to find the 
*	minimum spanning tree using Prim's algorithm and the shortest paths from a source
*	to all other vertices using Ford's algorithm to handle negative edge weights.
*
*   Date Written:		in the past
*
*   Date Last Revised:	4/8/2019
****************************************************************************************************/
#include <iostream>
#include <string>
#include "graph.h"


using namespace std;

int main()
{
	int choice;			//menu option
	int subChoice;
	double distance;	//shortest path

	//main graph
	Graph<vertex<string, int>, edgeRep<string, int>> graph;

	//vertices and the edge passed to the graph by the user
	vertex<string, int> firstVertex;
	vertex<string, int> secondVertex;
	edgeRep<string, int> edge;


	//start main menu do-while
	do
	{

		//menu options
		cout << "Graph Options." << endl;
		cout << "1. Read a graph from a file." << endl;
		cout << "2. Print the graph." << endl;
		cout << "3. Test if a vertex is in the graph." << endl;
		cout << "4. Test if an edge is in the graph." << endl;
		cout << "5. Add a vertex." << endl;
		cout << "6. Add an edge." << endl;
		cout << "7. Delete a vertex." << endl;
		cout << "8. Delete an edge." << endl;
		cout << "9. Traverse the graph." << endl;
		cout << "10. Find the shortest path between two vertices." << endl;
		cout << "11. Find the minimum spanning tree of the graph." << endl;
		cout << "12. Exit." << endl;

		//user input
		cout << "Enter the number of the option to select: ";
		cin >> choice;

		//menu validation
		while (cin.fail() || cin.peek() != '\n')
		{
			cin.clear();
			cin.ignore(200, '\n');
			cout << "\n\nIncorrect input.\nPlease enter an valid option number: " << endl;

			cin >> choice;
		}

		//start main menu switch
		switch (choice)
		{

		//get graph from file
		case 1:
			graph.GetGraph();
			cout << "\n\n" << endl;
			break;		//end main menu case 1 getting the graph

		//print the vertices and edges of the graph
		case 2:
			graph.SimplePrintGraph();
			cout << "\n\n" << endl;
			break;		//end main menu case 2 printing the graph

		//test if a vertex is in the graph
		case 3:

			//vertex to test
			cout << "\nEnter the name of the vertex to test (-1 to cancel): ";
			cin >> firstVertex.name;

			//allow for returning to main menu
			if (firstVertex.name == "-1")
			{
				cout << "\n\n" << endl;
				break;
			}

			//if the vertex is in the graph
			if (graph.isVertex(firstVertex) != -1)
				cout << firstVertex.name << " is in the graph.\n\n" << endl;

			//if the vertex is not in the graph
			else
				cout << firstVertex.name << " is not in the graph.\n\n" << endl;
			break;		//end main menu case 3 testing a vertex

		//test if an edge is in the graph
		case 4:
			
			//start sub menu for edges
			do
			{
				//sub menu options
				cout << "\nTesting if an edge is in the graph." << endl;
				cout << "1. Unidirectional Edge." << endl;
				cout << "2. Bidirectional Edge." << endl;
				cout << "3. Return" << endl;

				//sub menu selection
				cout << "Enter the number of the option to select: ";
				cin >> subChoice;

				//menu validation
				while (cin.fail() || cin.peek() != '\n')
				{
					cin.clear();
					cin.ignore(200, '\n');
					cout << "\n\nIncorrect input.\nPlease enter an valid option number: " << endl;

					cin >> subChoice;
				}

				//start sub menu switch
				switch (subChoice)
				{

				//test if an edge is unidirectional
				case 1:
					cout << "\nEnter the names of the two vertices to determine if a unidirectional edge exists between them. (-1 to cancel):" << endl;
					cout << "Vertex 1: ";
					cin >> firstVertex.name;

					//first vertex entered is not in the graph
					if (firstVertex.name == "-1")
					{
						cout << "\n\n" << endl;
						break;
					}

					//allow for returning to menu
					if (graph.isVertex(firstVertex) == -1)
					{
						cout << firstVertex.name << " is not in the graph.\n\n" << endl;
						break;
					}

					cout << "Vertex 2: ";
					cin >> secondVertex.name;

					//allow for returning to menu
					if (secondVertex.name == "-1")
					{
						cout << "\n\n" << endl;
						break;
					}

					//second vertex entered is not in the graph
					if (graph.isVertex(secondVertex) == -1)
					{
						cout << secondVertex.name << " is not in the graph.\n\n" << endl;
						break;
					}

					//unidirectional edge exists between vertices
					if (graph.isUniEdge(firstVertex, secondVertex) == 1)
						cout << "\n\nA unidirectional edge exists between " << firstVertex.name << " and " << secondVertex.name << endl;

					//unidirectional edge does not exist between vertices
					else
						cout << "\n\nNo unidirectional edge exists between " << firstVertex.name << " and " << secondVertex.name << endl;

					cout << "\n\n" << endl;
					break;		//end sub menu case 1 test unidirectional edge

				//test if an edge is bidirectional
				case 2:
					cout << "\nEnter the names of the two vertices to determine if a bidirectional exists between them. (-1 to cancel):" << endl;
					cout << "Vertex 1: ";
					cin >> firstVertex.name;

					//allow for returning to menu
					if (firstVertex.name == "-1")
					{
						cout << "\n\n" << endl;
						break;
					}

					//first vertex entered is not in the graph
					if (graph.isVertex(firstVertex) == -1)
					{
						cout << firstVertex.name << " is not in the graph.\n\n" << endl;
						break;
					}

					cout << "Vertex 2: ";
					cin >> secondVertex.name;

					//allow for returning to menu
					if (secondVertex.name == "-1")
					{
						cout << "\n\n" << endl;
						break;
					}

					//second vertex entered is not in the graph
					if (graph.isVertex(secondVertex) == -1)
					{
						cout << secondVertex.name << " is not in the graph.\n\n" << endl;
						break;
					}

					//bidirectional edge exists between vertices
					if (graph.isBiDirEdge(firstVertex, secondVertex) == 1)
						cout << "\n\nA bidirectional edge exists between " << firstVertex.name << " and " << secondVertex.name << endl;

					//bidirectional edge does not exist between vertices
					else
						cout << "\n\nNo bidirectional edge exists between " << firstVertex.name << " and " << secondVertex.name << endl;

					cout << "\n\n" << endl;
					break;		//end sub menu case 2 test bidirectional edge

				//return to main menu
				case 3:
					cout << "\n\n";
					break;		//end sub menu case 3
					
				//invalid sub menu option
				default:
					cout << "Invalid selection. Please enter a valid option." << endl;

				}	//end sub menu switch
			} while (subChoice != 3);	//end sub menu do-while

			break;		//end main menu case 4 testing an edge

		//add a vertex to the graph
		case 5:

			//vertex to add
			cout << "Enter the name of the vertex to add (-1 to cancel): ";
			cin >> firstVertex.name;

			//allow for returning to the menu
			if (firstVertex.name == "-1")
			{
				cout << "\n\n" << endl;
				break;
			}

			//add the vertex to the graph
			if (graph.AddVertex(firstVertex) == 0)
				cout << firstVertex.name << " added to the graph." << endl;
			cout << "\n\n" << endl;

			break;		//end main menu case 5 adding a vertex

		//add an edge to the graph
		case 6:

			//start sub menu do-while
			do {

				//sub menu options
				cout << "\nAdding an edge to the graph." << endl;
				cout << "1. Add a unidirectional edge." << endl;
				cout << "2. Add a bidirectional edge." << endl;
				cout << "3. Return." << endl;

				//sub menu selection
				cout << "Enter the number of the option to select: ";
				cin >> subChoice;

				//sub menu validation
				while (cin.fail() || cin.peek() != '\n')
				{
					cin.clear();
					cin.ignore(200, '\n');
					cout << "\n\nIncorrect input.\nPlease enter an valid option number: " << endl;

					cin >> subChoice;
				}
				
				//start sub menu switch
				switch (subChoice)
				{

				//add a unidirectional edge to the graph
				case 1:

					cout << "Enter the names of the two vertices to add a unidirectional edge between. (-1 to cancel)" << endl;

					//vertex to start the edge from
					cout << "Starting vertex: ";
					cin >> firstVertex.name;

					//allow for returning to menu
					if (firstVertex.name == "-1")
					{
						cout << "\n\n" << endl;
						break;
					}

					//vertex to end the edge at
					cout << "Ending vertex: ";
					cin >> secondVertex.name;

					//allow for returning to menu
					if (secondVertex.name == "-1")
					{
						cout << "\n\n" << endl;
						break;
					}

					//distance between the vertices or the weight of the edge
					cout << "Enter the distance between the two vertices: ";
					edge.name = firstVertex.name;
					cin >> edge.weight;

					//add the edge
					if (graph.AddUniEdge(firstVertex, secondVertex, edge) == 1)
						cout << "\n\nUnidirectional edge added between " << firstVertex.name << " and " << secondVertex.name << endl;

					cout << "\n\n" << endl;

					break;		//end sub menu case 1 adding a unidirectional edge

				//add a bidirectional edge to the graph
				case 2:
					cout << "Enter the names of the two vertices to add a bidirectional edge between. (-1 to cancel):" << endl;

					//first vertex to add the edge between
					cout << "Vertex 1: ";
					cin >> firstVertex.name;

					//allow returning to the menu
					if (firstVertex.name == "-1")
					{
						cout << "\n\n" << endl;
						break;
					}

					//second vertex to add the edge between
					cout << "Vertex 2: ";
					cin >> secondVertex.name;

					//allow returning to the menu
					if (secondVertex.name == "-1")
					{
						cout << "\n\n" << endl;
						break;
					}

					//distance between the vertices or the weight of the edge
					cout << "Enter the distance between the two vertices: ";
					edge.name = firstVertex.name;
					cin >> edge.weight;

					//add the edge
					graph.AddBiDirEdge(firstVertex, secondVertex, edge);
					cout << "\n\nBidirectional edge added between " << firstVertex.name << " and " << secondVertex.name << endl;
					cout << "\n\n" << endl;

					break;		//end sub menu case 2 adding a bidirectional edge

				//return to the main menu
				case 3:
					cout << "\n\n";
					break;		//end sub menu case 3

				//invalid sub menu option
				default:
					cout << "Invalid selection. Please enter a valid option." << endl;
					break;
				}

			} while (subChoice != 3);	//end sub menu do-while

			break;		//end main menu case 6 adding an edge

		//delete a vertex
		case 7:

			//vertex to delete
			cout << "Enter the name of the vertex to delete (-1 to cancel): ";
			cin >> firstVertex.name;

			//allow for returning to the main menu
			if (firstVertex.name == "-1")
			{
				cout << "\n\n" << endl;
				break;
			}

			//if the vertex is not in the graph, return to sub menu
			if (graph.isVertex(firstVertex) == -1)
			{
				cout << firstVertex.name << " is not in the graph.\n\n" << endl;
				break;
			}

			//delete the vertex
			if (graph.DeleteVertex(firstVertex) == 0)
				cout << "\n\n" << firstVertex.name << " deleted." << endl;
			cout << "\n\n" << endl;

			break;		//end main menu case 7 deleting a vertex

		//delete an edge
		case 8:
			do 
			{
				//sub menu options
				cout << "\nDeleting an edge from the graph." << endl;
				cout << "1. Delete a unidirectional edge." << endl;
				cout << "2. Delete a bidirectional edge." << endl;
				cout << "3. Return." << endl;

				//sub menu selection
				cout << "Enter the number of the option to select: ";
				cin >> subChoice;

				//sub menu validation
				while (cin.fail() || cin.peek() != '\n')
				{
					cin.clear();
					cin.ignore(200, '\n');
					cout << "\n\nIncorrect input.\nPlease enter an valid option number: " << endl;

					cin >> subChoice;
				}

				//start sub menu switch
				switch (subChoice)
				{

				//delete a unidirectional edge
				case 1:

					//the starting vertex of the edge to delete
					cout << "Enter the names of the two vertices to delete a unidirectional edge between. (-1 to cancel):" << endl;
					cout << "Vertex 1: ";
					cin >> firstVertex.name;

					//allow for returning to sub menu
					if (firstVertex.name == "-1")
					{
						cout << "\n\n" << endl;
						break;
					}

					//if the vertex is not in the graph, return to sub menu
					if (graph.isVertex(firstVertex) == -1)
					{
						cout << firstVertex.name << " is not in the graph.\n\n" << endl;
						break;
					}

					//the ending vertex of the edge to delete
					cout << "Vertex 2: ";
					cin >> secondVertex.name;

					//allow for returning to sub menu
					if (secondVertex.name == "-1")
					{
						cout << "\n\n" << endl;
						break;
					}

					//if the vertex is not in the graph, return to sub menu
					if (graph.isVertex(secondVertex) == -1)
					{
						cout << secondVertex.name << " is not in the graph.\n\n" << endl;
						break;
					}

					//delete the edge
					if (graph.DeleteUniEdge(firstVertex, secondVertex) == 1)
						cout << "\n\nEdge deleted between " << firstVertex.name << " and " << secondVertex.name << endl;

					break;		//end sub menu case 1 deleting a unidirectional edge

				//delete a bidirectional edge
				case 2:

					//the starting vertex of the edge to delete
					cout << "Enter the names of the two vertices to delete a bidirectional edge between. (-1 to cancel):" << endl;
					cout << "Vertex 1: ";
					cin >> firstVertex.name;

					//allow for returning to sub menu
					if (firstVertex.name == "-1")
					{
						cout << "\n\n" << endl;
						break;
					}

					//if the vertex is not in the graph, return to sub menu
					if (graph.isVertex(firstVertex) == -1)
					{
						cout << firstVertex.name << " is not in the graph.\n\n" << endl;
						break;
					}

					//the ending vertex of the edge to delete
					cout << "Vertex 2: ";
					cin >> secondVertex.name;

					//allow for returning to the sub menu
					if (secondVertex.name == "-1")
					{
						cout << "\n\n" << endl;
						break;
					}

					//if the vertex is not in the graph, return to the sub menu
					if (graph.isVertex(secondVertex) == -1)
					{
						cout << secondVertex.name << " is not in the graph.\n\n" << endl;
						break;
					}

					//delete the edge
					if (graph.DeleteBiDirEdge(firstVertex, secondVertex) == 1)
						cout << "\n\nEdge deleted between " << firstVertex.name << " and " << secondVertex.name << endl;
					cout << "\n\n" << endl;

					break;		//end sub menu case 2 deleting a bidirectional edge

				//return to the main menu
				case 3:
					cout << "\n\n";
					break;

				//invalid sub menu option
				default:
					cout << "Invalid selection. Please enter a valid option." << endl;
					break;
				}

			} while (subChoice != 3);		//end sub menu do-while

			break;		//end main menu case 8 deleting an edge
			
		//graph traversals
		case 9:

			//start sub menu do-while
			do {

				//traversal options
				cout << "\nTraversing the graph" << endl;
				cout << "1. Breadth First Traversal." << endl;
				cout << "2. Depth First Traversal." << endl;
				cout << "3. Return." << endl;

				//traversal selection
				cout << "Enter the number of the option to select: ";
				cin >> subChoice;

				//sub menu validation
				while (cin.fail() || cin.peek() != '\n')
				{
					cin.clear();
					cin.ignore(200, '\n');
					cout << "\n\nIncorrect input.\nPlease enter an valid option number: " << endl;

					cin >> subChoice;
				}

				//start sub menu switch
				switch (subChoice)
				{

				//breadth first traversal
				case 1:

					//the vertex to start the traversal at
					cout << "Breadth first traversal:" << endl;
					cout << "Enter the name of the vertex to start at (-1 to cancel): ";
					cin >> firstVertex.name;

					//allow for returning to the sub menu
					if (firstVertex.name == "-1")
					{
						cout << "\n\n" << endl;
						break;
					}

					//if the vertex is not in the graph, return to the sub menu
					if (graph.isVertex(firstVertex) == -1)
					{
						cout << firstVertex.name << " is not in the graph.\n\n" << endl;
						break;
					}

					//perform the breadth first traversal
					cout << "\n\nThe Breadth First Traversal of the graph is: " << endl;
					graph.BFTraversal(firstVertex);
					cout << "\n\n" << endl;

					break;		//end sub menu case 1 breadth first traversal

				//depth first traversal
				case 2:

					//the vertex to start the traversal at
					cout << "Depth first traversal:" << endl;
					cout << "Enter the name of the vertex to start at (-1 to cancel): ";
					cin >> firstVertex.name;

					//allow for returning to the sub menu
					if (firstVertex.name == "-1")
					{
						cout << "\n\n" << endl;
						break;
					}

					//if the vertex is not in the graph, return to the sub menu
					if (graph.isVertex(firstVertex) == -1)
					{
						cout << firstVertex.name << " is not in the graph.\n\n" << endl;
						break;
					}

					//perform the depth first traversal
					cout << "\n\nThe Depth First Traveral of the graph is: " << endl;
					graph.DFTraversal(firstVertex);
					cout << "\n\n" << endl;

					break;		//end sub menu case 2 depth first traversal

				//return to the main menu
				case 3:
					cout << "\n\n";
					break;
					
				//invalid sub menu option
				default:
					cout << "Invalid selection. Please enter a valid option." << endl;
					break;
				}

			} while (subChoice != 3);		//end traversal do-while

			break;		//end main menu case 9 traversals

		//shortest path algorithms
		case 10:

			//start sub menu do-while
			do {

				//shortest path options
				cout << "\nFinding the shortest path between two vertices in the graph." << endl;
				cout << "1. Using Dijkstra's Algorithm. (May not work for negative edge weights)" << endl;
				cout << "2. Using Ford's Algorithm." << endl;
				cout << "3. Return." << endl;

				//shortest path algorithm selection
				cout << "Enter the number of the option to select: ";
				cin >> subChoice;

				//sub menu validation
				while (cin.fail() || cin.peek() != '\n')
				{
					cin.clear();
					cin.ignore(200, '\n');
					cout << "\n\nIncorrect input.\nPlease enter an valid option number: " << endl;

					cin >> subChoice;
				}

				//start sub menu switch
				switch (subChoice)
				{

				//Dijkstra's algorithm
				case 1:

					//the starting vertex
					cout << "Enter the names of the two vertices to find the shortest path between them. (-1 to cancel)";
					cout << "\nVertex 1: ";
					cin >> firstVertex.name;

					//allow for returning to the sub menu
					if (firstVertex.name == "-1")
					{
						cout << "\n\n" << endl;
						break;
					}

					//if the vertex is not in the graph, return to the sub menu
					if (graph.isVertex(firstVertex) == -1)
					{
						cout << firstVertex.name << " is not in the graph.\n\n" << endl;
						break;
					}

					//the ending vertex
					cout << "Vertex 2: ";
					cin >> secondVertex.name;

					//allow for returning to the sub menu
					if (secondVertex.name == "-1")
					{
						cout << "\n\n" << endl;
						break;
					}

					//if the vertex is not in the graph, return to the sub menu
					if (graph.isVertex(secondVertex) == -1)
					{
						cout << secondVertex.name << " is not in the graph.\n\n" << endl;
						break;
					}

					//find the shortest path between the starting vertex and the ending vertex
					distance = graph.ShortestDistance(firstVertex, secondVertex);

					//if the distance is not -1, a path exists
					//print the path
					if (distance != -1)
						cout << "\n\nThe shortest distance between " << firstVertex.name << " and " << secondVertex.name << " is " << distance << "\n\n" << endl;

					//a path does not exist
					else
						cout << "\n\nThe shortest distance between " << firstVertex.name << " and " << secondVertex.name << " is nonexistant.\n\n" << endl;

					break;		//end Dijkstra's algorithm

				//Ford's algorithm
				case 2:
					
					//the starting vertex
					cout << "Enter the names of the two vertices to find the shortest path between them. (-1 to cancel)";
					cout << "\nVertex 1: ";
					cin >> firstVertex.name;

					//allow for returning to the sub menu
					if (firstVertex.name == "-1")
					{
						cout << "\n\n" << endl;
						break;
					}

					//if the vertex is not in the graph, return to the sub menu
					if (graph.isVertex(firstVertex) == -1)
					{
						cout << firstVertex.name << " is not in the graph.\n\n" << endl;
						break;
					}

					//find all of the shortest paths
					graph.FordShortestPath(firstVertex);

					break;		//end Ford's algorithm

				//return to the main menu
				case 3:
					cout << "\n\n";
					break;

				//invalid sub menu selection
				default:
					cout << "Invalid selection. Please enter a valid option." << endl;
					break;
				}

			} while (subChoice != 3);		//end shortest path sub menu do-while

			break;		//end main menu case 10 shortest paths

		//minimum spanning tree algorithm
		case 11:

			//starting vertex
			cout << "Enter the name of the starting vertex to find the minimum spanning tree from. (-1 to cancel): " << endl;
			cin >> firstVertex.name;

			//allow for returning to the main menu
			if (firstVertex.name == "-1")
			{
				cout << "\n\n" << endl;
				break;
			}

			//if the vertex is not in the graph, return to the main menu
			if (graph.isVertex(firstVertex) == -1)
			{
				cout << firstVertex.name << " is not in the graph.\n\n" << endl;
				break;
			}

			//find the minimum spanning tree using Prim's algorithm
			graph.MST(firstVertex);

			break;		//end main menu case 11 minimum spanning tree

		//exit the program
		case 12:
			cout << "Exitting." << endl;
			break;

		//invalid main menu option
		default:
			cout << "\n\nPlease enter a valid option number: " << endl;
			break;
		}

	} while (choice != 12);		//end main menu do-while

	return 0;
}
