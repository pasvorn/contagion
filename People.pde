
class People {
  
  final float MAXVEL = 10;
  final int blimit = 5;
  final int get_well_day = 140;
  final int MAXBOUND = 300;
  final int well_color = 0x4FFFFFFF;
  final int sick_color = 0x4FFF0000;
  final int immune_color = 0x8F00ff00;

  int myindex;
  float xlocation, ylocation;
  float xbound[] = new float[2];
  float ybound[] = new float[2];
  float xvel, yvel;
  float gotsick =0;
  float sickedat = 0.0;
  float getwellat = 0.0;
  int spreader = 0;
  boolean sick = false;
  boolean immune = false;
  int mycolor;
  float vfactor = 1.0;
  
  People( int index) {
    xlocation = random(0, width);
    ylocation = random(9, height);
    xvel = random(-MAXVEL, MAXVEL);
    yvel = random(-MAXVEL, MAXVEL);
    float xspan = random(10, MAXBOUND);
    float yspan = random(10, MAXBOUND);
    xbound[0] = xlocation - xspan;
    xbound[1] = xlocation + xspan;
    ybound[0] = ylocation - yspan;
    ybound[1] = ylocation + yspan;
    mycolor = well_color;
    myindex = index;
    gotsick = 0;
  }
  
  void move(int framenumber) {
    getbetter(framenumber);
    xlocation += xvel*vfactor;
    ylocation += yvel*vfactor;
    if (xlocation > xbound[1] | xlocation < xbound[0] ) xvel *= -1.0;
   
    if (ylocation > ybound[1] | ylocation < ybound[0]) yvel *= -1.0;
     
  }
  
  boolean meet(People OtherPeople) {
    if (myindex == OtherPeople.myindex) return false;
    boolean result = ( abs(xlocation - OtherPeople.xlocation) < 5 &
             abs(ylocation - OtherPeople.ylocation) < 5 );
    //if (result) println(" meet: ", myindex, OtherPeople.myindex);
    return result;
  }
  
  void contact(People OtherPeople) {
     if( sicked() ) {
        if( !OtherPeople.sicked() ) {
            if( random(0,1.0) < 0.4) {
              OtherPeople.getsick(framenumber);
              spreader++;
            }
        }
     } else if ( OtherPeople.sicked()) {
          if ( random(0,1.0) < 0.4) {
            getsick(framenumber);
            OtherPeople.spreader++;
          }
     } 
  }
  
  void getsick(int framenumber) {
    if (mycolor != immune_color) {
      mycolor = sick_color;
      gotsick = framenumber;
      sickedat = framenumber;
      getwellat = framenumber + random(120,200);
      //println(myindex, " got sicked at ", framenumber);
      vfactor = 0.4;
    }
  }
  
  // people should get better after being sicked 
  void getbetter(int framenumber) {
    if (getwellat > 0 & framenumber > getwellat ) {
      mycolor = well_color;
      mycolor = immune_color;
      gotsick = 0;
      vfactor = 1.0;
    }
  }
  
  void collision() {
      xvel *= -1; yvel *= -1;
  }
  
  boolean sicked( ) {
    return gotsick > 0;
  }
  
  void draw() {
    fill(mycolor);
    circle(xlocation,ylocation,10);
  }
  
} // end of People class
