using System;
using System.IO;
using System.Linq;
using System.Collections.Generic;

class Program {
	static Dictionary<string, ulong> seen = new Dictionary<string, ulong>();
	static void Main(string[] args) {
		ulong sum = 0;
		string path = "input.txt";
		string[] lines = File.ReadAllLines(path);
		foreach (string line in lines) {
			var (springs, groups) = line.Split(' ') switch { var a => (
				a[0],
				a[1].Split(',').Select(x => int.Parse(x)).ToList()
			) };
			sum += TestLine(
				String.Join("?", Enumerable.Repeat(springs, 5).ToArray()),
				Enumerable.Repeat(new List<int>(groups), 5)
					.SelectMany(x => x).ToList()
			);
		}
		Console.WriteLine(sum);
	}

	static ulong TestLine(string springs, List<int> groups, int run = 0) {
		Dictionary<string, ulong> partiallySeen = new Dictionary<string, ulong>();
		ulong sum = 0;
		for (int i = 0; i < springs.Length; i++) {
			string id = springs.Substring(i) + " " + String.Join(",", groups) + " " + run;
			if (seen.ContainsKey(id)) {
				return seen[id];
			}
			switch (springs[i]) {
				case '.':
					if (run > 0) {
						if (groups.Count > 0 && groups[0] == run) {
							groups.RemoveAt(0);
							run = 0;
						}
						else {
							seen.Add(id, sum);
							ProcessSeen(partiallySeen, sum);
							return sum;
						}
					}
					break;
				case '#':
					if (groups.Count == 0) {
						seen.Add(id, sum);
						ProcessSeen(partiallySeen, sum);
						return sum;
					}
					run++;
					break;
				case '?':
					if (groups.Count > 0) {
						sum += TestLine(
							'#' + springs.Substring(i + 1),
							new List<int>(groups),
							run
						);
					}
					sum += TestLine(
						'.' + springs.Substring(i + 1),
						groups,
						run
					);
					seen.Add(id, sum);
					ProcessSeen(partiallySeen, sum);
					return sum;
				default:
					throw new Exception("Invalid spring");
			}
			if (groups.Sum() + groups.Count - 1 > springs.Length - i + run) {
				seen.Add(id, sum);
				ProcessSeen(partiallySeen, sum);
				return sum;
			}
			partiallySeen.Add(id, sum);
		}
		if (groups.Count == 0 || groups[0] == run) {
			sum++;
		}
		return sum;
	}
	
	static void ProcessSeen(Dictionary<string, ulong> partiallySeen, ulong sum) {
		foreach (var item in partiallySeen) {
			seen.Add(item.Key, sum - item.Value);
		}
	}
}