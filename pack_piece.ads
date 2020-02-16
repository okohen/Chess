with  pack_file_gen;

package pack_piece is

   type t_valeur is (null_p,pion,tour,cavalier,fou,dame,roi);
   type t_couleur is (blanc,noir,transparent);

   type tcase is record
      posx:integer;
      posy:integer;
   end record;
   procedure afficherpos(p:tcase);




   package file_gen_deplacement is new pack_file_gen(14,tcase,afficherpos);
   use file_gen_deplacement;



   type t_piece is record
      valeur:t_valeur;
      couleur:t_couleur;
      position:tcase;

      haut:file_gen_deplacement.tfile;
      bas:file_gen_deplacement.tfile;
      droite:file_gen_deplacement.tfile;
      gauche:file_gen_deplacement.tfile;
      haut_droite:file_gen_deplacement.tfile;
      bas_droite:file_gen_deplacement.tfile;
      bas_gauche:file_gen_deplacement.tfile;
      haut_gauche:file_gen_deplacement.tfile;

   end record;

   type T_fileCasePossibles is record
      mapiece:t_piece;
      casePossible:tcase;
   end record;
   procedure affichercase(tfpiece:in T_fileCasePossibles);

   package file_gen_TfileCases is new pack_file_gen(64,pack_piece.T_fileCasePossibles,affichercase);
   use file_gen_TfileCases;





end pack_piece;
