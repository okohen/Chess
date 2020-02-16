with ada.Text_IO,ada.Integer_Text_IO;
use ada.Text_IO,ada.Integer_Text_IO;
with ada.Strings.Maps, Ada.Wide_Text_IO,Ada.Characters.Latin_1,Ada.Characters.Wide_Latin_1;
use  Ada.Strings.Maps;
with Ada.Characters.Handling;
use ada.Characters.Handling;

package body pack_plateau is

   function "=" (p:in tcase;p2:in tcase) return Boolean
   is
   begin
      return p.posx=p2.posx and p.posy=p2.posy;
   end "=";

   ----------------------------------------------------------------------------
   procedure afficherPlateau(jeu:in  Tplateau) is
   begin
      New_Line;
      Put("      A     B     C     D     E     F     G     H "); New_Line;
      for i in jeu'First..jeu'Last loop
         put("   +-----+-----+-----+-----+-----+-----+-----+-----+"); New_Line;put(i,1); put("  |");
         for j in jeu'First..jeu'Last loop
            -- affichage dans Adagide
            if jeu(i,j).valeur=null_p then
               put("     |");
            else 
               if(jeu(i,j).couleur=noir) then
                  ada.Text_IO.Put("  "&t_valeur'Image(jeu(i,j).valeur)(1)& "  |"); 
               else if jeu(i,j).couleur=blanc then
                     ada.Text_IO.Put(" ("&To_Lower(t_valeur'Image(jeu(i,j).valeur)(1))& ") |");       
                  end if;
               end if;
            end if;
            ---------------------------------------------------------------
            -------- Affichage colorer qui marche dans gps ide ------------ Voir Capture d'ecran 
            --              if jeu(i,j).valeur=null_p then
            --                 put("     |");
            --              else          
            --                 if(jeu(i,j).couleur=noir) then
            --                    Ada.Wide_Text_IO.Put ( "  "& Ada.Characters.Wide_Latin_1.ESC &    "[31m");
            --                    ada.Text_IO.Put(t_valeur'Image(jeu(i,j).valeur)(1));
            --                    ada.Wide_Text_IO.Put(Ada.Characters.Wide_Latin_1.ESC &   "[0m" & "  ");
            --                 else if jeu(i,j).couleur=blanc then
            --                       Ada.Wide_Text_IO.Put (  "  "& Ada.Characters.Wide_Latin_1.ESC &    "[34m");
            --                       ada.Text_IO.Put(t_valeur'Image(jeu(i,j).valeur)(1));
            --                       ada.Wide_Text_IO.Put(Ada.Characters.Wide_Latin_1.ESC &   "[0m"  & "  ");
            --                    end if;
            --                   end if;
            --                 put("|");
            --            end if;
         end loop;
         ada.Text_IO.New_Line;
      end loop;
      Put_Line("   +-----+-----+-----+-----+-----+-----+-----+-----+");
   end afficherPlateau;

   ------------------------------------------------------------------------------------------
   --Procedure AjoutePieceSutPlateau
   --supprime la piece de la case precedente
   --Met a jour la postion de la Piece
   --Ajoute une piece a la case donnée
   Procedure AjoutePieceSurPlateau( piece : in out T_piece; mycase : Tcase; Plateau :in out Tplateau)is
      pi_null:t_piece;
   begin
      --supprime la piece de la case precedente
      pi_null.valeur:=null_p;
      pi_null.couleur:=transparent;
      Plateau(piece.position.posy,piece.position.posx):=pi_null;
      --Met a jour la postion de la Piece
      piece.position.posx:=mycase.posx;
      piece.position.posy:=mycase.posy;
      --Ajoute une piece a la case donnée
      Plateau(mycase.posy,mycase.posx):=piece;
   end AjoutePieceSurPlateau;
   ------------------------------------------------------------------------------------
   --Procedure InitPlateau
   --Init tous le plateau avec des Pieces Null_p et couleur Transparent
   procedure initPlateau(jeu: in out Tplateau) is
      p_null:t_piece;
   begin
      p_null.valeur:=null_p;
      p_null.couleur:=transparent;
      for i in 1..8 loop
         for j in 1..8 loop
            jeu(i,j):=p_null;
         end loop;
      end loop;
   end initPlateau;

   ------------------------------------------------------------------------------------------
   --Procedure RemplirePlateau
   --ajouter toutes les pieces du joueur passer en parametre

   procedure remplirePlateau(jeu:in out Tplateau;jou : in t_joueur) is
      fcp:file_gen_piece.tfile:=jou.listep;
      mycase:tcase;
      pi_toadd:t_piece;

   begin
      while not file_gen_piece.filevide(fcp) loop
         mycase.posx:=file_gen_piece.filelire(fcp).position.posx;
         mycase.posy:=file_gen_piece.filelire(fcp).position.posy;
         pi_toadd:=file_gen_piece.filelire(fcp);
         if pi_toadd.valeur/=null_p then
            AjoutePieceSurPlateau(pi_toadd, mycase,jeu);
         end if;
         file_gen_piece.defiler(fcp);
      end loop;

   end remplirePlateau;
   ------------------------------------------------------------------------------------------
   --Procedure Mini_dep
   --parcours la file direction passée en parametre
   --calcul l'offset+ position actuel
   --si inclus dans le tab et la pos est libre
   -- enfiler Mafile
   --Arreter quand la l'offset+ position = Piece adversaire
   --enfiler la file attacker
   --Sortir
   procedure mini_dep(madir :in file_gen_deplacement.tfile; file:in out file_gen_TfileCases.tfile;file_A_attacker:in out file_gen_TfileCases.tfile;jeu:in Tplateau;piece:in t_piece) is
      macasepossible : T_fileCasePossibles;
      direction:file_gen_deplacement.tfile:=madir;
      x,y:Integer;
      Stop:Boolean:=false;
   begin
      if not file_gen_deplacement.filevide(direction) then
         macasepossible.mapiece:=piece; -- ma piece qui menace les autres
         x:=file_gen_deplacement.filelire(direction).posx + Piece.position.posx;
         y:=file_gen_deplacement.filelire(direction).posy + Piece.position.posy;
         while not file_gen_deplacement.filevide(direction) and Stop=False loop
            x:=file_gen_deplacement.filelire(direction).posx + Piece.position.posx;
            y:=file_gen_deplacement.filelire(direction).posy + Piece.position.posy;
            if  ((x<=8 and x>=1) and (y<=8 and y>=1) ) and then  jeu(y,x).couleur=piece.couleur then
               Stop:=True;
            else if (((x<=8 and x>=1) and (y<=8 and y>=1) )  and then (jeu(y,x).couleur/=piece.couleur) )then--manger qu'un seul pion
                  macasepossible.casePossible.posx:=file_gen_deplacement.filelire(direction).posx;--offset
                  macasepossible.casePossible.posy:=file_gen_deplacement.filelire(direction).posy;
                  if ( jeu(y,x).couleur/=transparent and jeu(y,x).couleur/=piece.couleur) then
                     if piece.valeur=pion and file_gen_deplacement.filelire(direction).posx=0 then --check type and importance
                        stop:=False;                                                               --piece advers a attacker
                     else
                        file_gen_TfileCases.enfiler(file_A_attacker,macasepossible);
                        Stop:=True;
                     end if;
                  end if;
                  if stop /=True then
                     file_gen_TfileCases.enfiler(file,macasepossible);
                  end if;
               end if;
            end if;
            if piece.valeur=pion and file_gen_deplacement.filelire(direction).posx/=0 then
               stop:=True;
            else
               file_gen_deplacement.defiler(direction);
            end if;
         end loop;
      end if;
   end mini_dep;

   ------------------------------------------------------------------------------------------
   -- cette fonction retourne soit une liste de deplacement
   -- soit une liste de PION,dame... a attacker
   -- IMPORTANT§§§§
   -- ce que tu dois faire c'est creer une fonction qui trie  la liste file_a_attacker avant de la retourner
   --selon l'ordre d'importance
   Function getListeDeplacementsPossibles( jeu : Tplateau; Piece : T_piece ) return file_gen_TfileCases.tfile is
      mafile:file_gen_TfileCases.tfile;
      file_A_attacker:file_gen_TfileCases.tfile;
   begin
      file_gen_TfileCases.fileinit(file_A_attacker);
      file_gen_TfileCases.fileinit(mafile);
      --verification haut_gauche , gauche , bas_gauche
      mini_dep(Piece.haut, mafile,file_A_attacker,jeu,piece);
      mini_dep(Piece.bas, mafile,file_A_attacker,jeu,piece);
      mini_dep(Piece.gauche, mafile,file_A_attacker,jeu,piece);
      mini_dep(Piece.droite, mafile,file_A_attacker,jeu,piece);
      mini_dep(Piece.haut_droite, mafile,file_A_attacker,jeu,piece);
      mini_dep(Piece.haut_gauche, mafile,file_A_attacker,jeu,piece);
      mini_dep(Piece.bas_droite, mafile,file_A_attacker,jeu,piece);
      mini_dep(Piece.bas_gauche, mafile,file_A_attacker,jeu,piece);
      if not file_gen_TfileCases.filevide(file_A_attacker) then
         return file_A_attacker;
      else
         return mafile;
      end if;
   end getListeDeplacementsPossibles;
   -----------------------------------------------------------------------------
   --Fonction Brain
   --Chercher les pieces que je menace et attaquer
   --sinon se deplacer
   procedure brain(joueur:in out t_joueur;joueur_advrs:in t_joueur; jeu: in out Tplateau) is
      listep_a_traiter,tfilecase:file_gen_tfilecases.tfile;
      cp_listep:file_gen_piece.tfile;
      piece:t_piece;
      new_case:tcase;
      stop:Boolean:=False;
   begin
      file_gen_TfileCases.fileinit(listep_a_traiter);
      cp_listep :=joueur.listep;
      -- je cherche si je peux attaquer
      while not file_gen_piece.filevide(cp_listep) and stop=False loop
         listep_a_traiter:= getListeDeplacementsPossibles(jeu,file_gen_piece.filelire(cp_listep));
         if not file_gen_TfileCases.filevide(listep_a_traiter) then
            new_case.posx:=file_gen_TfileCases.filelire(listep_a_traiter).mapiece.position.posx+file_gen_TfileCases.filelire(listep_a_traiter).casePossible.posx;
            new_case.posy:=file_gen_TfileCases.filelire(listep_a_traiter).mapiece.position.posy+file_gen_TfileCases.filelire(listep_a_traiter).casePossible.posy;
            -- Si mapiece + offset = piece advrs
            if jeu(new_case.posy, new_case.posx).couleur=joueur_advrs.couleur then-- si oui j'attaque et je sort de la boucle
               piece:=file_gen_TfileCases.filelire(listep_a_traiter).mapiece;
               AjoutePieceSurPlateau(piece,new_case,jeu);
               stop:=True;
            end if;
         end if;
         file_gen_piece.defiler(cp_listep);
      end loop;
      if stop =False then   --sinon je me deplace
         while not file_gen_piece.filevide(joueur.listep) and stop =False loop
            piece:=file_gen_piece.filelire(joueur.listep);
            tfilecase:=pack_plateau.getListeDeplacementsPossibles(jeu,piece);--liste deplacement possible
            if not file_gen_TfileCases.filevide(tfilecase) then
               new_case.posx:=file_gen_TfileCases.filelire(tfilecase).casePossible.posx+file_gen_TfileCases.filelire(tfilecase).mapiece.position.posx;
               new_case.posy:=file_gen_TfileCases.filelire(tfilecase).casePossible.posy+file_gen_TfileCases.filelire(tfilecase).mapiece.position.posy;
               AjoutePieceSurPlateau(piece,new_case,jeu);
               stop:=True;
            end if;
            file_gen_piece.defiler(joueur.listep);
         end loop;
      end if;
      file_gen_piece.defiler(joueur.listep);
   end brain;

   ---------------------------------------------------------------------------------------------
   --retourne une case
   function return_piece(p:in Tplateau;x,y:in Integer) return t_piece is
   begin
      return p(y,x);
   end return_piece;
   --------------------------------------------------------------------------
   --Procedure Maj_joueur
   --Mets a jour la liste de pieces d'un joueur
   --a partir des pieces rester sur le plateau
   procedure maj_joueur(joueur:in out t_joueur;jeu:in Tplateau) is
      file_tmp:file_gen_piece.tfile;
   begin
      file_gen_piece.fileinit(file_tmp);
      for i in 1..8 loop
         for j in 1..8 loop
            if jeu(i,j).couleur=joueur.couleur then
               file_gen_piece.enfiler(file_tmp,jeu(i,j));
            end if;
         end loop;
      end loop;
      while not file_gen_piece.filevide(joueur.listep) loop
         file_gen_piece.defiler(joueur.listep);
      end loop;
      joueur.listep:=file_tmp;

   end maj_joueur;

   ----------------------------------------------------------------------------
   procedure joueur_manuellement(joueur_manu: in out t_joueur; Plateau:in out Tplateau)is
      rep:Integer;
      macase:tcase;
      liste_dep:file_gen_TfileCases.tfile;
      piece:t_piece;
      cp_listep:file_gen_piece.tfile;
   begin
      cp_listep:=joueur_manu.listep;
      Put_Line("Joueur 1");
      file_gen_piece.fileaffiche(cp_listep);
      put("rep: ");
      get(rep);
      for i in 1..rep loop
         file_gen_piece.defiler(cp_listep);
      end loop;
      piece:=file_gen_piece.filelire(cp_listep);
      liste_dep:=getListeDeplacementsPossibles(Piece => piece,jeu => Plateau);
      file_gen_TfileCases.fileaffiche(liste_dep);
      if not file_gen_TfileCases.filevide(liste_dep) then
         put("selection position propose : ");
         get(rep);
         for i in 1..rep loop
            file_gen_TfileCases.defiler(liste_dep);
         end loop;
         macase.posx :=file_gen_TfileCases.filelire(liste_dep).casePossible.posx+piece.position.posx;
         macase.posy:=file_gen_TfileCases.filelire(liste_dep).casePossible.posy+piece.position.posy;
         AjoutePieceSurPlateau(piece => piece,Plateau=>Plateau,mycase => macase);
      else
         joueur_manuellement(joueur_manu, Plateau);
      end if;
   end joueur_manuellement; 
   --------------------------------------------------------------------------
   --Des fonctions que j'avais fait mais qui prenaient beaucoup de temps pour s'executer
   --------------------------------------------------------------------------
   --     la fonction Brain avant.
   --     je rentrais dans des boucles infinis quand je devais attaquer.
   -------------------------------Debut fct Brain -----------------------------------
   --         listep_a_traiter:=chercher_piece_menacer(joueur_advrs,jeu);--liste de mes piece menace
   --
   --        --j'ai ma liste je vais voir si je peux attaquer ou je me deplace
   --        listep_queje_menace:=chercher_piece_menacer(joueur,jeu);-- liste que je menace
   --
   --        --je dois voir si je suis menacer
   --        --si oui
   --        -- je vois si je peux attaquer;
   --        --ou je me deplace;
   --
   --        -- je dois faire une intersection
   --
   --        -- si je suis menacer
   --        if not file_gen_TfileCases.filevide(listep_a_traiter) then
   --           -- si je menace des piece je fais l'intersect
   --                       put("if listep_a_traiter not vide");
   --           if not file_gen_TfileCases.filevide(listep_queje_menace) then -- je fais l'intersection
   --                                   put("if ma liste not vide");
   --              while not file_gen_TfileCases.filevide(listep_queje_menace) loop
   --                 cp_listep_a_traiter:=listep_a_traiter;
   --                 put("boucle while 1");
   --
   --                 pos.posx:=file_gen_TfileCases.Filelire(listep_a_traiter).mapiece.position.posx+file_gen_TfileCases.Filelire(listep_a_traiter).casePossible.posx;
   --                 pos.posy:=file_gen_TfileCases.Filelire(listep_a_traiter).mapiece.position.posy+file_gen_TfileCases.Filelire(listep_a_traiter).casePossible.posy;
   --
   --
   --                 while not file_gen_TfileCases.filevide(cp_listep_a_traiter) loop
   --      put("boucle while 2");
   --                    if file_gen_TfileCases.filelire(listep_a_traiter).mapiece.position=pos then    -- si je peux attaquer une piece qui me menace
   --
   --                       file_gen_TfileCases.enfiler(listep_intersect, file_gen_TfileCases.filelire(listep_a_traiter));--les pieces avec les quelle je peux attaquer
   --                       --les pieces menaceante que je peux attaquer
   --
   --                    end if;
   --                 end loop;
   --
   --                 file_gen_TfileCases.defiler(listep_queje_menace);
   --              end loop;
   --           end if;
   --           put("if liste vide");
   --        end if;
   --
   --        --j'aurai les pieces qui me menace et que je peux attaquer
   --
   --        if not file_gen_TfileCases.filevide(listep_intersect) then
   --           put("if intersect");
   --           -- si oui j'attaque
   --           --- mais avant je dois trier les pieces que je vais attaquer
   --           cpt:=1;
   --           r.valeur:=null_p; d.valeur:=null_p;
   --           fct.valeur:=null_p;    p.valeur:=null_p;
   --           cp_listep_intersect:=listep_intersect;
   --           while not file_gen_TfileCases.filevide(cp_listep_intersect) and indice_pos=0 loop
   --              put("boucle while 3 intersect");
   --              piece_attaque:=file_gen_TfileCases.filelire(cp_listep_intersect).mapiece;
   --
   --              x:=piece_attaque.position.posx+file_gen_TfileCases.filelire(cp_listep_intersect).casePossible.posx;
   --              y:=piece_attaque.position.posy+file_gen_TfileCases.filelire(cp_listep_intersect).casePossible.posy;
   --
   --              if jeu(y,x).valeur=roi then
   --                 --je tire les pieces a attaque selon ordre d'
   --                 r:=jeu(y,x);-- piece a attaque
   --                 att_r:=piece_attaque;
   --
   --              else if jeu(y,x).valeur=dame then
   --                    d:=jeu(y,x);
   --
   --                    att_d:=piece_attaque;
   --                 else if  jeu(y,x).valeur=fou or jeu(y,x).valeur=cavalier or jeu(y,x).valeur=tour  then
   --                       fct:=jeu(y,x);
   --
   --                       att_fct:=piece_attaque;
   --                    else if jeu(y,x).valeur=pion then
   --                          p:=jeu(y,x);
   --
   --                          att_p:=piece_attaque;
   --                       end if;
   --                    end if;
   --                 end if;
   --              end if;
   --
   --              file_gen_TfileCases.defiler(cp_listep_intersect);
   --
   --           end loop;
   --           ---j'attaque
   --
   --           if r.valeur/=null_p then -- avec ma piece j'attaque sa case;
   --              AjoutePieceSurPlateau(att_r,r.position, jeu);
   --           else if d.valeur/=null_p then
   --                 AjoutePieceSurPlateau(att_r,r.position, jeu);
   --              else if fct.valeur/=null_p then
   --                    AjoutePieceSurPlateau(att_r,r.position, jeu);
   --                 else if p.valeur/=null_p then
   --                       AjoutePieceSurPlateau(att_r,r.position, jeu);
   --
   --                       --                    else
   --                       --                       --sinon je me deplace ...
   --                       --                       piece:=file_gen_piece.filelire(joueur.listep);
   --                       --                       tfilecase:=pack_plateau.getListeDeplacementsPossibles(jeu,piece);
   --                       --                       if not file_gen_TfileCases.filevide(tfilecase) then
   --                       --                          pack_piece.file_gen_TfileCases.fileaffiche(tfilecase);
   --                       --
   --                       --                          new_case.posx:=file_gen_TfileCases.filelire(tfilecase).casePossible.posx+piece.position.posx;
   --                       --                          new_case.posy:=file_gen_TfileCases.filelire(tfilecase).casePossible.posy+piece.position.posy;
   --                       --
   --                       --                          AjoutePieceSurPlateau(piece,new_case,jeu);
   --                       --                          --  deplacerpiecesurplateau(piece,new_case, p,j,j2);
   --                       --
   --                       --
   --                       --                      -- file_gen_piece.defiler(joueur.listep);
   --                       --                      -- file_gen_piece.enfiler(joueur.listep,piece);
   --                       piece:=file_gen_piece.filelire(joueur_advrs.listep);
   --                       tfilecase:=pack_plateau.getListeDeplacementsPossibles(jeu,piece);
   --                       if not file_gen_TfileCases.filevide(tfilecase) then
   --                          pack_piece.file_gen_TfileCases.fileaffiche(tfilecase);
   --
   --                          new_case.posx:=file_gen_TfileCases.filelire(tfilecase).casePossible.posx+file_gen_TfileCases.filelire(tfilecase).mapiece.position.posx;
   --                          new_case.posy:=file_gen_TfileCases.filelire(tfilecase).casePossible.posy+file_gen_TfileCases.filelire(tfilecase).mapiece.position.posy;
   --
   --                          AjoutePieceSurPlateau(piece,new_case,jeu);
   --                          --  deplacerpiecesurplateau(piece,new_case, p,j,j2);
   --                       end if;
   --                    end if;
   --                 end if;
   --              end if;
   --           end if;
   --
   --        end if;
   --
   ----------------------------------------- Fin  Brain ---------------------------

   --------------------------------------------------------------------------------
   --     function chercher_piece_menacer (joueur_advrs:in t_joueur; jeu:in Tplateau) return file_gen_tfilecases.tfile is
   --        cp_listep:file_gen_piece.tfile:=joueur_advrs.listep;
   --        listep_menacer:file_gen_TfileCases.tfile;
   --        piece:t_piece;
   --        x,y:Integer;
   --        maliste:file_gen_TfileCases.tfile;
   --     begin
   --
   --        file_gen_TfileCases.fileinit(listep_menacer);
   --
   --        --parcourir toutes les pieces de mon adversaire
   --        while not file_gen_piece.filevide(cp_listep) loop
   --
   --           piece:=file_gen_piece.filelire(cp_listep);
   --
   --           listep_menacer:=getListeDeplacementsPossibles(jeu,piece);-- retourne la liste de piece qu'on peut attacker
   --
   --           -- piece +offset
   --
   --           if not file_gen_TfileCases.filevide(listep_menacer) then
   --              x:=file_gen_TfileCases.filelire(listep_menacer).mapiece.position.posx+ file_gen_TfileCases.filelire(listep_menacer).casePossible.posx;
   --              y:=file_gen_TfileCases.filelire(listep_menacer).mapiece.position.posy+ file_gen_TfileCases.filelire(listep_menacer).casePossible.posy;
   --              if jeu(y,x).couleur/=transparent then -- si !casevide c'est une liste d'attaque;
   --                 while not file_gen_TfileCases.filevide(listep_menacer) loop
   --                    --copier mes pieces menacer
   --                    file_gen_TfileCases.enfiler(maliste,file_gen_TfileCases.filelire(listep_menacer));
   --                    file_gen_TfileCases.defiler(listep_menacer);
   --                 end loop;
   --              end if;
   --           end if;
   --           file_gen_piece.defiler(cp_listep);
   --
   --        end loop;--jusqu'ici j'ai mes piece menacer et les piece qui me menace
   --
   --
   --        return maliste;
   --     end chercher_piece_menacer;
   --------------------------------------------------------------------------------

   --
   --     function Roi_exist(joueur: in t_joueur; joueur2:in t_joueur) return Boolean
   --     is
   --        cp_listep1,cp_listep2:file_gen_piece.tfile;
   --        roi1,roi2:Boolean:=True;
   --     begin
   --        cp_listep1:=joueur.listep;
   --        cp_listep2:=joueur2.listep;
   --        while not file_gen_piece.filevide(cp_listep1) and roi1 loop
   --
   --           if file_gen_piece.filelire(cp_listep1).valeur=roi then
   --              roi2=False;
   --           end if;
   --        end loop;
   --
   --        while not file_gen_piece.filevide(cp_listep2) and roi2 loop
   --
   --           if file_gen_piece.filelire(cp_listep1).valeur=roi then
   --              roi1=False;
   --           end if;
   --        end loop;
   --        return roi1=False and roi2=False;
   --
   --
   --     end Roi_exist;


   ----------------------------------------------------------------------------
   --     --Piece importante a attacker par une piece;
   --     --prendre la file de piece a attacker et retourner la piece sensible
   --     --
   --     --
   --     function PlPieces_menacer(liste:in out file_gen_TfileCases.tfile) return file_gen_piece.tfile is
   --        cp_liste,cp2_liste:file_gen_TfileCases.tfile:=liste;
   --
   --        listep_sensible:file_gen_piece.tfile;
   --        piece_max:t_piece;
   --     begin
   --        file_gen_piece.fileinit(listep_sensible);
   --
   --        --chercher le max
   --        piece_max:=file_gen_TfileCases.filelire(cp_liste).mapiece;
   --
   --        while not file_gen_TfileCases.filevide(cp_liste) loop
   --
   --           if(file_gen_TfileCases.filelire(cp_liste).mapiece.valeur>piece_max.valeur) then
   --
   --              piece_max:=file_gen_TfileCases.filelire(cp_liste).mapiece;
   --
   --           end if;
   --
   --           file_gen_TfileCases.defiler(cp_liste);
   --
   --        end loop;
   --        ---- enfiler les max
   --
   --        while not file_gen_TfileCases.filevide(cp2_liste) loop
   --
   --           if(file_gen_TfileCases.filelire(cp2_liste).mapiece.valeur=piece_max.valeur) then
   --
   --              file_gen_piece.enfiler(listep_sensible,file_gen_TfileCases.filelire(cp2_liste).mapiece);
   --
   --           end if;
   --
   --           file_gen_TfileCases.defiler(cp2_liste);
   --
   --        end loop;
   --
   --        return listep_sensible;
   --
   --        -- liste mes piece sensible harceler par l'autre
   --        --on cherche liste de piece qui harcele
   --
   --     end PlPieces_menacer;
   --     -------------------------------------------
   --     function  Piece_menacer_sensible (joueur_advers :in t_joueur; jeu : in  Tplateau) return t_piece is
   --        cp_listep:file_gen_piece.tfile:=joueur_advers.listep;
   --
   --        lpieces_sensible:file_gen_TfileCases.tfile;
   --
   --        listep_tres_sensible:file_gen_piece_S.tfile;
   --
   --        listep_menacente,listep_sensible:file_gen_piece.tfile;
   --
   --        piece_menacente:t_piece;
   --
   --        attacker,defendre:t_piece;
   --     begin
   --
   --      --  file_gen_piece.fileinit(pieces_sensible);
   --
   --        file_gen_piece.fileinit(listep_sensible);
   --
   --        file_gen_piece.fileinit(listep_menacente);
   --
   --       while not file_gen_piece.filevide(cp_listep) loop
   --
   --           piece_menacente:=file_gen_piece.filelire(cp_listep);
   --           --pour chaque piece -- on  prend les attackes
   --           lpieces_sensible:=pack_plateau.getListeDeplacementsPossibles( jeu, piece_menacente);
   --           -- si menacente
   --           if file_gen_TfileCases.filelire(lpieces_sensible).mapiece.couleur/=transparent then
   --              --on copie la liste des pieces qharceler
   --
   --              -- on enregistre la piece menacente
   --              file_gen_piece.enfiler(listep_menacente,piece_menacente); -- piece de l'autre --
   --
   --              --on enregistre les pieces menacer
   --              --on prend les pieces importante
   --  --  --            on a les cases sensible;
   --  --               listep_sensible:=PlPieces_menacer(lpieces_sensible);--mes pieces --
   --  --
   --  --              while not file_gen_piece.filevide(listep_sensible) loop
   --  --  --               on copie les piece sensible;
   --  --
   --  --                 file_gen_piece_S.enfiler(listep_tres_sensible,file_gen_piece.filelire(listep_sensible));-- copier les top pieces
   --  --
   --  --                 file_gen_piece.defiler(listep_sensible);
   --  --
   --  --              end loop;
   --
   --              --on a la liste des piece harceler par les autre piece
   --              -- mnt supprimer les double et prendre la plus importante
   --              -- piece harceler et la piece qui l'harcel
   --           end if;
   --
   --
   --
   --           file_gen_piece.defiler(cp_listep);
   --
   --       end loop;
   --
   --        --apres avoir copier ses pieces menaceante(his)
   --        --         mes  piece sensibles-(mine)
   --
   --        -- on doit les classes pour attacker et defendre
   --
   --        --top de ses pieces
   --        --top de mes pieces
   --
   --        --- je trie par ordre d'importance des deux coté
   --
   --
   --        attacker:=
   --
   --
   --
   --
   --        return
   --
   --     end Piece_menacer_sensible;

   --
   --     procedure get_piece_sensible(listep:in out file_gen_piece_S) return t_piece is
   --     begin
   --
   --        while not file_gen_piece_S.filevide(listep) loop
   --
   --
   --
   --        end loop;
   --
   --
   --
   --
   --     end get_piece_sensible;


end pack_plateau;
