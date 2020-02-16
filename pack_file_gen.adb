with Ada.Text_IO,ada.Integer_Text_IO;
use ada.Text_IO,ada.Integer_Text_IO;

package body pack_file_gen is

   procedure fileinit(f:out tfile) is
   begin
      f.Tete:=1;
      f.nbe:=0;
   end fileinit;

   function filevide(f:tfile) return Boolean is
   begin
      return f.nbe=0;
   end filevide;

   function filepleine(f:tfile) return Boolean is
   begin
      return f.nbe=Filemax;
   end filepleine;

   function filelire(f:tfile) return tinconnu is
   begin
      return f.Fil(f.tete);
   end filelire;

   procedure enfiler(f:in out tfile; v:in tinconnu) is
      queue : integer:= f.tete+f.nbe;
   begin
      if not filepleine(f) then
         if queue >Filemax then
            queue:=queue-Filemax;
         end if;
         f.Fil(queue):=v;
         f.nbe:=f.nbe+1;
      else
         put_line("Erreur enfiler : filepleine");
      end if;
   end enfiler;

   procedure defiler(f:in out tfile) is
   begin
      if not filevide(f) then
         if f.Tete=Filemax then
            f.Tete:=1;
         else
            f.tete:=f.tete+1;
         end if;
         f.nbe:=f.nbe-1;
      else
         Put_Line("Erreur defiler: file vide");
      end if;
   end defiler;



   procedure fileaffiche(f:in tfile) is
      f2:tfile:=f;
      cpt:Integer:=0;
   begin
      while not filevide(f2) loop
         put(cpt);
         afficher(filelire(f2));
         defiler(f2);
         cpt:=cpt+1;
      end loop;
   end fileaffiche;





end pack_file_gen;
