with pack_joueur,pack_piece,pack_file_gen,ada.Text_IO,pack_plateau,ada.Integer_Text_IO;
use pack_joueur,pack_piece,ada.Text_IO,pack_plateau,ada.Integer_Text_IO;

procedure Main is
   j,j2:t_joueur;
   plateau:Tplateau;
   cp_listep1,cp_listep2:file_gen_piece.tfile;
   rep:Integer:=-1;
begin
   chargement_joueur(j,blanc); chargement_joueur(j2,noir);
   initPlateau(plateau);
   remplirePlateau(plateau,j); remplirePlateau(plateau,j2);
   afficherPlateau(plateau);
   Put_Line("1. Pc vs Pc ");
   Put_Line("2. Joueur vs Pc");
   Put("Entrer votre choix : ");
   Get(rep);
   if rep=1 then
      cp_listep1:=j.listep;
      cp_listep2:=j2.listep;
      while (not file_gen_piece.filevide(cp_listep1) ) and (not file_gen_piece.filevide(cp_listep2)) loop

         cp_listep1:=j.listep;
         cp_listep2:=j2.listep;
         Put_Line("Joueur 1");
         brain(j,j2,plateau);
         afficherPlateau(plateau);
         maj_joueur(j,plateau);
         maj_joueur(j2,plateau);
         initPlateau(plateau);
         remplirePlateau(plateau,j);
         remplirePlateau(plateau,j2);
         Put_Line("Joueur 2");
         brain(j2,j,plateau);
         afficherPlateau(plateau);
         maj_joueur(j,plateau);
         maj_joueur(j2,plateau);
         initPlateau(plateau);
         remplirePlateau(plateau,j);
         remplirePlateau(plateau,j2);

         file_gen_piece.defiler(cp_listep1);
         file_gen_piece.defiler(cp_listep2);
         Put_Line("#####################################");
      end loop;
   end if;
   if rep=2 then
      cp_listep1:=j.listep;
      cp_listep2:=j2.listep;
      while (not file_gen_piece.filevide(cp_listep1) ) and (not file_gen_piece.filevide(cp_listep2)) loop
         cp_listep1:=j.listep;
         cp_listep2:=j2.listep;
         joueur_manuellement(j,plateau);
         afficherPlateau(plateau);
         maj_joueur(j,plateau);
         maj_joueur(j2,plateau);
         initPlateau(plateau);
         remplirePlateau(plateau,j);
         remplirePlateau(plateau,j2);
         Put_Line("Joueur 2");
         brain(j2,j,plateau);
         afficherPlateau(plateau);
         maj_joueur(j,plateau);
         maj_joueur(j2,plateau);
         initPlateau(plateau);
         remplirePlateau(plateau,j);
         remplirePlateau(plateau,j2);

         file_gen_piece.defiler(cp_listep1);
         file_gen_piece.defiler(cp_listep2);
         Put_Line("#####################################");
      end loop;
   end if;
   afficherPlateau(plateau);



end Main;
