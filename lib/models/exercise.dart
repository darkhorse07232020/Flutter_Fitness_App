/*
  class Exercise
  Author: Sophie(bolesalavb@gmail.com)
  Created Date & Time:  June 8 2020 12:25 PM

  Descrition: Exercise Object
*/
class Exercise {
  final String name;
  int rep;
  int time;

  Exercise({
    this.name,
    this.rep = 0,
    this.time = 0,
  });

  /*
    void addTime(int time)
    Author: Sophie(bolesalavb@gmail.com)
    Created Date & Time: June 8 2020 5:48 PM

    Function: addTime

    Descrtion: Add time

    Parameters: time(int) - adding time
  */
  void addTime(int time) { 
      this.time += time; 
   } 

  /*
    void addRep(int rep)
    Author: Sophie(bolesalavb@gmail.com)
    Created Date & Time: June 8 2020 5:50 PM

    Function: addRep

    Descrtion: Add rep

    Parameters: rep(int) - adding rep
  */
  void addRep(int rep) { 
      this.rep += rep; 
   } 
}