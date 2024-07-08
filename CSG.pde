import java.util.Comparator;

class HitCompare implements Comparator<RayHit>
{
  int compare(RayHit a, RayHit b)
  {
     if (a.t < b.t) return -1;
     if (a.t > b.t) return 1;
     if (a.entry) return -1;
     if (b.entry) return 1;
     return 0;
  }
}
class RHHHitCompare implements Comparator<RHH>
{
  int compare(RHH a, RHH b)
  {
     if (a.hit.t < b.hit.t) return -1;
     if (a.hit.t > b.hit.t) return 1;
     if (a.hit.entry) return -1;
     if (b.hit.entry) return 1;
     return 0;
  }
}

class Union implements SceneObject
{
  SceneObject[] children;
  Union(SceneObject[] children)
  {
    this.children = children;
    // remove this line when you implement true unions
    //println("WARNING: Using 'fake' union");
  }

  ArrayList<RayHit> intersect(Ray r)
  {
     
     ArrayList<RayHit> hits = new ArrayList<RayHit>();
     
     // Reminder: this is *not* a true union
     // For a true union, you need to ensure that enter-
     // and exit-hits alternate
     for (SceneObject sc : children)
     {
       hits.addAll(sc.intersect(r));
     }
     hits.sort(new HitCompare());
     
     ArrayList<RayHit> toReturn = new ArrayList<RayHit>(); 
     int count = 0;
     for(int i = 0; i < hits.size(); i++)
       if(count == 0 && hits.get(i).entry){
         toReturn.add(hits.get(i));
         count++;
       } else if (count == 1 && !hits.get(i).entry){
         toReturn.add(hits.get(i));
         count--;
       } else if(hits.get(i).entry){
         count++;
       } else if(!hits.get(i).entry){
         count--;
       }   
     return toReturn;
  }
}

class Intersection implements SceneObject
{
  SceneObject[] elements;
  Intersection(SceneObject[] elements)
  {
    this.elements = elements;

    // remove this line when you implement intersection
    //throw new NotImplementedException("CSG Operation: Intersection not implemented yet");
  }
  ArrayList<RayHit> intersect(Ray r)
  {
     
     ArrayList<RayHit> hits = new ArrayList<RayHit>();
     int size = 0;
     
     for (SceneObject sc : elements)
     {
       size++;
       hits.addAll(sc.intersect(r));
     }
     hits.sort(new HitCompare());
     int count = 0; //initialize to how many objects we started out inside of and boom done
     ArrayList<RayHit> toReturn = new ArrayList<RayHit>(); 
     
     
     
     
     for(int i = 0; i < hits.size();i++ ){
       if(count == (size - 1) && hits.get(i).entry){
         toReturn.add(hits.get(i));
         count++;
       }else if(count == 0 && !hits.get(i).entry){
         toReturn.add(hits.get(i));
         count--;
       }else if(hits.get(i).entry){
         count++;
       }else if(!hits.get(i).entry){
         count--;
       }
     }
       
     return toReturn;
  }
}

class Difference implements SceneObject
{
  SceneObject a;
  SceneObject b;
  Difference(SceneObject a, SceneObject b)
  {
    this.a = a;
    this.b = b;
    
    // remove this line when you implement difference
    //throw new NotImplementedException("CSG Operation: Difference not implemented yet");
  }
  
  ArrayList<RayHit> intersect(Ray r)
  {
     ArrayList<RHH> hits = new ArrayList<RHH>();
     ArrayList<RayHit> hitsa = new ArrayList<RayHit>();
     ArrayList<RayHit> hitsb = new ArrayList<RayHit>();
     
     hitsa.addAll(a.intersect(r));
     hitsb.addAll(b.intersect(r));
     
     for(RayHit h: hitsa){
       hits.add(new RHH(h, true));
     }
     
     for(RayHit h: hitsb){
       hits.add(new RHH(h, false));
     }
     
     hits.sort(new RHHHitCompare());
     hitsa.sort(new HitCompare());
     hitsb.sort(new HitCompare());
     
     boolean ina, inb;
     
     ArrayList<RayHit> toReturn = new ArrayList<RayHit>(); 
     
     if(hitsa.size() == 0){
       return toReturn;
     }else if(hitsb.size() == 0){
       return toReturn;
     }
     ina = !hitsa.get(0).entry;
     inb = !hitsb.get(0).entry;
     
     for(RHH rh : hits){
       boolean orig_entry = rh.hit.entry;
       if(ina && !inb){
         if(rh.hit.entry){
           rh.hit.entry = false;
           rh.hit.normal = PVector.mult(rh.hit.normal, -1);
           toReturn.add(rh.hit);
         }else if(!rh.hit.entry){
           toReturn.add(rh.hit);
         }
       }
       
       
       if(rh.isa){
         ina = orig_entry;
       }else if(!rh.isa){
         inb = orig_entry;
       }
       
       
       if(ina && !inb){
         if(rh.hit.entry){
           toReturn.add(rh.hit);
         }else if(!rh.hit.entry){
           rh.hit.entry = true;
           rh.hit.normal = PVector.mult(rh.hit.normal, -1);
           toReturn.add(rh.hit);
         }
       }
     }  
     return toReturn;
  }
  
}
