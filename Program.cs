using System;
using System.Collections;
using System.Collections.Generic;
using System.Diagnostics;

namespace PerformanceTest
{
    class Program
    {
        public static int N = 10000000;
        //public static int N = 100;
        static void Main(string[] args)
        {
            var p = new Program();
            var array = new int[N];
            var arrayList = new ArrayList(N);
            var list = new List<int>(N);

            string choice = (args.Length > 0) ? args[0] : string.Empty;

            switch (choice)
            {
                case "array":
                    Console.WriteLine(p.TaskArray(array));
                    Console.WriteLine(" ");
                    break;

                case "list":
                    Console.WriteLine(p.TaskList(list));
                    Console.WriteLine(" ");
                    break;

                case "array_list":
                    Console.WriteLine(p.TaskArrayList(arrayList));
                    Console.WriteLine(" ");
                    break;

                default:                 
                    Console.WriteLine(p.TaskArray(array));
                    Console.WriteLine(p.TaskList(list));
                    Console.WriteLine(p.TaskArrayList(arrayList));
                    break;

            }
        }

        public  string TaskList(List<int> list)
        {
           var populate  =  Measure(
                "Generic List: populate: ",
                () =>
                {
                    for (int x = 0; x < N; x++)
                    {
                        list.Add(x);
                    }
                }
            );
            var gcInfo1 = PrintGCInfo();

           var summation = Measure(
          "Generic List summation: ",
          () =>
          {
              int sum = 0;
              for (int x = 0; x < N; x++)
              {
                  sum += list[x];
              }
          }
          );
            var gcInfo2 = PrintGCInfo();            
            return string.Format("Generic List,{0},{1},{2},{3}", populate, summation, gcInfo1, gcInfo2);
        }

        public string TaskArray(int[] array)
        {
            var populate = Measure(
                "Regular Array populate: ",
                () =>
                {
                    for (int x = 0; x < N; x++)
                    {
                        array[x] = x;
                    }
                }
            );

            var gcInfo1 = PrintGCInfo();
            
            var summation = Measure(
           "Regular Array summation: ",
           () =>
           {
               int sum = 0;
               for (int x = 0; x < N; x++)
               {
                   sum += array[x];
               }
           }
           );
            var gcInfo2 = PrintGCInfo();
            return string.Format("Regular Array,{0},{1},{2},{3}", populate, summation, gcInfo1, gcInfo2);
        }

        public string TaskArrayList(ArrayList arrayList)
        {
           var populate =  Measure(
            "ArrayList populate: ",
            () =>
            {
                for (int x = 0; x < N; x++)
                {
                    arrayList.Add(x);
                }
            }
            );
            var gcInfo1 = PrintGCInfo();
            
            var summation = Measure(
            "ArrayList summation: ",
            () =>
            {
                int sum = 0;
                for (int x = 0; x < N; x++)
                {
                    sum += (int)arrayList[x];
                }
            }
            );
           var gcInfo2 = PrintGCInfo();
            return string.Format("ArrayList,{0},{1},{2},{3}", populate, summation, gcInfo1, gcInfo2);
        }

        public string Measure(string msg, Action task)
        {
            var sw = new Stopwatch();
            sw.Start();
            task();
            sw.Stop();
            return sw.ElapsedMilliseconds.ToString(); ;
        }

        public string PrintGCInfo()
        {
            var gc0 = GC.CollectionCount(1);
            var gc1 = GC.CollectionCount(2);
            var gc2 = GC.CollectionCount(3);

            //Console.WriteLine("Gen 0: {0}, Gen 1: {1}, Gen 2: {2}", gc0, gc1, gc2);
            return string.Format("{0},{1},{2}", gc0, gc1, gc2);
        }
    }
}
