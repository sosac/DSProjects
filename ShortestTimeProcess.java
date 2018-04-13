/**
 * DS 730: project final - due 5/3/2016
 * Connie Sosa - date 5/5/2016
 */

import java.io.File;
import java.io.*;
import java.util.Scanner;

	/****************************************************
	 * @param fname : file name - text file to be processed
	 */
	public class ShortestTimeProcess {
		private static EdgeCollection curEdgeCollect = null;   // NTOE eclipse suggested fix add static
		private static int shortTime = Integer.MAX_VALUE;
		private static String shortestRoute = "";
				
		static void findAllPaths(int[] building, int numBuilding)
		{
			String key;
			String currentRoute;
			int totalTime;
						
			// if there are multiple shortest paths, it will only return one of them
			currentRoute = "";
			totalTime = 0;
			if (numBuilding == building.length)
			{
				for (int i = 1; i < building.length; i++)
				{
					if (i == 1) {
						key = "1,"+building[i];
//						System.out.print(" "+key);
						currentRoute = currentRoute + "("+key+") ";
						totalTime = totalTime + (curEdgeCollect.getEdge(key).getEdgeTime());
					} else {
						key = building[i-1] + "," + building[i];
//						System.out.print(" "+key);
						currentRoute = currentRoute + "("+key+") ";
						totalTime = totalTime + (curEdgeCollect.getEdge(key).getEdgeTime());
					}
				}
					
				key = building[numBuilding-1] + ",1";
//				System.out.print(" "+key);		
				currentRoute = currentRoute + "("+key+") ";
				totalTime = totalTime + (curEdgeCollect.getEdge(key).getEdgeTime());
//				System.out.println();
				
				if (totalTime < shortTime) {
					shortTime = totalTime;
					shortestRoute = currentRoute;
					totalTime = 0; // reset time
				}
			}
			else
			{
				int len2 = building.length;
				for (int i = numBuilding; i < len2; i++)
				{
					int swap = building[numBuilding];
					building[numBuilding] = building[i];
					building[i] = swap;					
					findAllPaths(building, numBuilding+1);					
					swap = building[numBuilding];
					building[numBuilding] = building[i];
					building[i] = swap;
				}
			}
		} // end of findAllPaths				
		
		/**************************************************** 
		* @param file : input file to process
		*/
			public static void processFile(String file) {			
				
				Scanner fileScanner;
				String currentLine = "";
				int len;
				int numBuilds;
				String line[];
				String travelTimes[];
				String buildingName;
				String times;
				String outputfile;
				Edge currentEdge;
				numBuilds = 0;
				curEdgeCollect = new EdgeCollection();
				
				try {
					fileScanner = new Scanner(new File(file));

					while (fileScanner.hasNextLine()) {
						numBuilds++;
						currentLine = fileScanner.nextLine();
						line = currentLine.split(":"); 
						buildingName = line[0].trim();	
						times = line[1].trim();
			    		travelTimes = times.split("\\s+");
			    		len = travelTimes.length;
			    		int i;
		    			for (i=0;  i < len; i++) {	    			
			    			currentEdge = new Edge(buildingName, Integer.toString(i+1), Integer.parseInt(travelTimes[i]));			    			
			    			curEdgeCollect.addEdge(currentEdge.getName(), currentEdge);						    			
			    		}		    		
					} // end of while
					//curEdgeCollect.printEdges();
					
					// find all possible paths from possible edges:
					// n buildings: (n-1)! possible paths
					// 4 buildings: 1 x 3 x 2 x 1 x 1 (origin and destination is buildingOne)
					//              need to traverse all other buildings in between				
					int[] buildings = new int[numBuilds];
					for (int i = 1; i < numBuilds; i++)
					{
						buildings[i] = i+1; // don't permute building 1, starts w/ b2  
					}
					findAllPaths(buildings, 1);			
					
					outputfile = "output2B"+numBuilds+".txt";
					try {
						PrintWriter fw = new PrintWriter(outputfile);
						fw.print("Shortest visiting " +numBuilds+ " buildings route takes "  + shortTime + " seconds:");
						fw.println(shortestRoute);
						fw.close();
					} catch (IOException e) {
						e.printStackTrace();
					}
					System.out.print("Shortest visiting " +numBuilds+ " buildings route takes "  + shortTime + " seconds:");
					System.out.println(shortestRoute);
					if (fileScanner != null) {
						fileScanner.close();	
					}		     			   	
				} catch (Exception e) {
					System.out.println("Errors: " + e);	          
				} 
		} // end of processFile() 			
	} // end of ShortestTimeProcess
