generic
   Filemax : integer;
   type Tinconnu is private;
   with procedure afficher(x: in tinconnu);

package pack_file_gen is
   type tfile is private;

   procedure fileinit(f:out tfile);
   function filevide(f:tfile) return boolean;
   function filepleine(f:tfile) return Boolean;
   function filelire(f:tfile) return tinconnu;
   procedure enfiler(f:in out tfile; v:in tinconnu);
   procedure defiler(f:in out tfile);
   procedure fileaffiche(f:in tfile);

private
   subtype Indice is Integer range 0..Filemax;
   subtype Indicefile is Indice range 1..Filemax;
   type TabFile is array(IndiceFile) of Tinconnu;--generic
   TYPE TFile IS RECORD
      Tete : Indice := 1;
      nbe: integer:=0;
      Fil : TabFile;
   end record;



end pack_file_gen;
