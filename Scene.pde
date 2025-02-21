class RayHit
{
     float t;
     PVector location;
     PVector normal;
     boolean entry;
     Material material;
     float u, v;
}

class RHH
{
  RayHit hit;
  boolean isa;
  
  RHH(RayHit hit, boolean isa){
    this.hit = hit;
    this.isa = isa;
  }
}

interface SceneObject
{
   ArrayList<RayHit> intersect(Ray r);
}

class Scene
{
   LightingModel lighting;
   SceneObject root;
   int reflections;
   color background;
   PVector camera;
   PVector view;
   float fov;
}
