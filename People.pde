/** Pasvorn Boonmark Copyright May 2, 2020
 * People class to mimic random people behavior moving withing a 2D plane
 * The first portion of a People's properties are constant definding boundary
 * values that governs one's behaviors. The are defined are follow:
 * MAXVEL = maximum velocity that one can move per frame - unit in pixel
 * Blimit = boundary limit - use for detecting if a People is within contact
 *    range of another People
 * get_well_day = when a People is sick, how many "days he will get better
 *    the value is in number of frame since one got sick
 * MAXBOUND = govern a boundary that one travel. This is artificial number.
 *    according to US Transport survey, we travel 40 miles per day on an
 *    average. So this should reflect that - see www.bts.gov - 2017-05-31
 * The following are color of a People based on one's status:
 *    - well_color when one is well
 *    - sick_color when one is sick
 *    - immune_color when one is immune
 * The state diagram of a Person is as follow:
 *    Current State | next states | Trigger
 *      well            sick      | contact a sick People with 40% chance
 *      sick        |   immune    | after sick for "get_well_day"

 */
class People {
  
  final float MAXVEL = 3;
  final int Blimit = 5;
  final int get_well_day = 140;
  final int MAXBOUND = 300;
  final int well_color = 0x4FFFFFFF;
  final int sick_color = 0x4FFF0000;
  final int immune_color = 0x8F00ff00;
  final float sick_v_factor = 0.1;

  int myindex;
  boolean debug = false;
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

    // 
    People( int index) {
    // initialize a People's properties
    xlocation = random(0, width);
    ylocation = random(9, height);
    // how fast one traveled
    xvel = random(-MAXVEL, MAXVEL);
    yvel = random(-MAXVEL, MAXVEL);
    
    // Boundary a Person can be - essentially allocated 2xrandom number
    float xspan = random(50, MAXBOUND);
    float yspan = random(50, MAXBOUND);
    xbound[0] = xlocation - xspan;
    xbound[1] = xlocation + xspan;
    ybound[0] = ylocation - yspan;
    ybound[1] = ylocation + yspan;
    mycolor = well_color;
    myindex = index;
    gotsick = 0;
    }

    // when a People moves - check to make sure one is within one's bound
    void move(int framenumber) {
    getbetter(framenumber);
    xlocation += xvel*vfactor;
    ylocation += yvel*vfactor;
    if (xlocation > xbound[1] | xlocation < xbound[0] )
        xvel *= -1.0;
    if (ylocation > ybound[1] | ylocation < ybound[0])
        yvel *= -1.0;
    }

    // meet - when one People meets another People
    boolean meet(People OtherPeople) {
    if (myindex == OtherPeople.myindex) return false;
    boolean result = ( abs(xlocation - OtherPeople.xlocation) < Blimit &
             abs(ylocation - OtherPeople.ylocation) < Blimit );
    if (debug & result)
        println(" meet: ", myindex, OtherPeople.myindex);
    return result;
    }

    // giving a chance, will a People gets sick
    boolean get_sick_chance (float chance) {
      return random(0,1.0) < chance;
    }
    
    // contact - this is when contact is made. People can get sick here
    void contact(People OtherPeople) {
    if( sicked() ) {
        if( !OtherPeople.sicked() ) {
        if( get_sick_chance(0.4) ) {
            OtherPeople.getsick(framenumber);
            spreader++;
        }
        }
    } else if ( OtherPeople.sicked()) {
        if ( get_sick_chance(0.4) ) {
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
    textSize(16);
    text(spreader,xlocation+5, ylocation);
    circle(xlocation,ylocation,10);
  }
  
} // end of People class
