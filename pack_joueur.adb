with ada.Text_IO;
use ada.Text_IO;

package body pack_joueur is
   ----------------------------------------------------------------------------
   --Procedure saisi
   --Affect des valeur par defaut au joueur ( a modifier apres)
   procedure saisi(j:in out t_joueur;coul:t_couleur) is
   begin
      j.couleur:=coul;
      j.name:="AA";
      file_gen_piece.fileinit(j.listep);
   end saisi;
   ----------------------------------------------------------------------------
   --Procedure afficher
   --Afficher les info d'un joueur
   procedure afficher(j:in t_joueur) is
   begin
      put(j.name);New_Line;
      put(t_couleur'Image(j.couleur));
   end afficher;
   ----------------------------------------------------------------------------
   --Procedure Printpiece
   --Afficher une piece avec toutes ses offset
   procedure printPiece(x:t_piece) is
      tableaux:String(1..8):="ABCDEFGH";
      copy:t_piece:=x;
   begin
      put(" "&t_valeur'Image(x.valeur)&" : ");
      put(t_couleur'Image(x.couleur)& " " & tableaux(x.position.posx) & " " & Integer'Image(x.position.posy)); New_Line;
   end printpiece;

   procedure initpiece(piece: in out t_piece) is
   begin
      file_gen_deplacement.fileinit(piece.haut);
      file_gen_deplacement.fileinit(piece.bas);
      file_gen_deplacement.fileinit(piece.droite);
      file_gen_deplacement.fileinit(piece.gauche);
      file_gen_deplacement.fileinit(piece.haut_droite);
      file_gen_deplacement.fileinit(piece.bas_droite);
      file_gen_deplacement.fileinit(piece.bas_gauche);
      file_gen_deplacement.fileinit(piece.haut_gauche);
   end;

   ---------------------------------------------------------------------------
   --Procedure chargement_joueur
   --Instanciation Joueur;  (saisi(joueur,couleur ) )
   --Instanciation toutes les directions de piece ( initpiece(piece) )
   --Instancier toutes les offset
   procedure chargement_joueur(jou:in out t_joueur;couleur:in t_couleur) is
      p,t,c,f,r,d:t_piece;
      mypo:tcase;
      a,b,cx:Integer:=0;--Reverse tab
      ry:Integer:=1;--Reverse y
   begin
      if couleur=noir then
         a:=7;
         cx:=-9;
         b:=5;
         ry:=-1;
      end if;
      --Init_Joueur
      pack_joueur.saisi(jou,couleur);
      --Instantiation piece (init tous les File direction)
      initpiece(p);initpiece(t);initpiece(c);
      initpiece(f);initpiece(r);initpiece(d);
      -------------------------------------------------------------------------------
      mypo.posx:=0;
      mypo.posy:=1*ry;
      file_gen_deplacement.enfiler(p.haut,mypo); --Pion
      mypo.posx:=-1*ry;
      mypo.posy:=1*ry;
      file_gen_deplacement.enfiler(p.haut_droite,mypo); --Pion
      mypo.posx:=1*ry;
      mypo.posy:=1*ry;
      file_gen_deplacement.enfiler(p.haut_gauche,mypo); --Pion
      for i in 1..7 loop
         mypo.posx:=0;
         mypo.posy:=i*ry;
         file_gen_deplacement.enfiler(t.haut,mypo);

         file_gen_deplacement.enfiler(d.haut,mypo); --reine
         --bas
         mypo.posx:=0;
         mypo.posy:=(-i)*ry;
         file_gen_deplacement.enfiler(t.bas,mypo);
         file_gen_deplacement.enfiler(d.bas,mypo);--reine
         --droite
         mypo.posx:=i;
         mypo.posy:=0;
         file_gen_deplacement.enfiler(t.droite,mypo);
         file_gen_deplacement.enfiler(d.droite,mypo); --reine
         --gauche
         mypo.posx:=-i;
         mypo.posy:=0;
         file_gen_deplacement.enfiler(t.gauche,mypo);
         file_gen_deplacement.enfiler(d.gauche,mypo);--reine
         --fou --------------------------------
         mypo.posx:=i;
         mypo.posy:=i*ry;
         file_gen_deplacement.enfiler(f.haut_droite,mypo);
         file_gen_deplacement.enfiler(d.haut_droite,mypo);--reine
         mypo.posx:=-i;
         mypo.posy:=(-i)*ry;
         file_gen_deplacement.enfiler(f.bas_gauche,mypo);
         file_gen_deplacement.enfiler(d.bas_gauche,mypo);--reine
         mypo.posx:=i;
         mypo.posy:=(-i)*ry;
         file_gen_deplacement.enfiler(f.bas_droite,mypo);
         file_gen_deplacement.enfiler(d.bas_droite,mypo);--reine
         mypo.posx:=-i;
         mypo.posy:=i*ry;
         file_gen_deplacement.enfiler(f.haut_gauche,mypo);
         file_gen_deplacement.enfiler(d.haut_gauche,mypo);--reine
         ------------------------------------------
      end loop;
      --tour
      t.valeur:=tour;
      t.couleur:=couleur;
      t.position.posx:=abs(1+cx);
      t.position.posy:=1+a;
      file_gen_piece.enfiler(jou.listep,t);

      t.valeur:=tour;
      t.couleur:=couleur;
      t.position.posx:=abs(8+cx);
      t.position.posy:=1+a;
      file_gen_piece.enfiler(jou.listep,t);
      --pion dans tab
      for i in  1..8 loop
         p.valeur:=pion;
         p.couleur:=couleur;
         p.position.posx:=abs(i+cx);
         p.position.posy:=2+b;
         file_gen_piece.enfiler(jou.listep,p);
      end loop;
      -------------------------------------------------------------------------------
      --Cavalier
      mypo.posx:=2;
      mypo.posy:=1*ry;
      file_gen_deplacement.enfiler(c.haut_droite,mypo);
      mypo.posx:=1;
      mypo.posy:=2*ry;
      file_gen_deplacement.enfiler(c.droite,mypo);
      mypo.posx:=2;
      mypo.posy:=(-1)*ry;
      file_gen_deplacement.enfiler(c.haut_gauche,mypo);
      mypo.posx:=1;
      mypo.posy:=(-2)*ry;
      file_gen_deplacement.enfiler(c.bas_droite,mypo);
      mypo.posx:=-2;
      mypo.posy:=1*ry;
      file_gen_deplacement.enfiler(c.gauche,mypo);
      mypo.posx:=-1;
      mypo.posy:=2*ry;
      file_gen_deplacement.enfiler(c.haut,mypo);
      mypo.posx:=-2;
      mypo.posy:=(-1)*ry;
      file_gen_deplacement.enfiler(c.bas_gauche,mypo);
      mypo.posx:=-1;
      mypo.posy:=(-2)*ry;
      file_gen_deplacement.enfiler(c.bas,mypo);
      --Cavalier x2
      c.valeur:=cavalier;
      c.couleur:=couleur;
      c.position.posx:=abs(2+cx);
      c.position.posy:=1+a;
      file_gen_piece.enfiler(jou.listep,c);

      c.position.posx:=abs(7+cx);
      c.position.posy:=1+a;
      file_gen_piece.enfiler(jou.listep,c);
      -------------------------------------------------------------------------------
      --Dame(Reine)

      d.valeur:=dame;
      d.couleur:=couleur;
      d.position.posx:=abs(5+cx);
      d.position.posy:=1+a;
      file_gen_piece.enfiler(jou.listep,d);
      --Fou x2
      f.valeur:=fou;
      f.couleur:=couleur;
      f.position.posx:=abs(3+cx);
      f.position.posy:=1+a;
      file_gen_piece.enfiler(jou.listep,f);

      f.position.posx:=abs(6+cx);
      f.position.posy:=1+a;
      file_gen_piece.enfiler(jou.listep,f);
      ------------------------------------------------------------------------------
      mypo.posx:=1;
      mypo.posy:=1*ry;
      file_gen_deplacement.enfiler(r.haut_droite,mypo);
      mypo.posx:=1;
      mypo.posy:=0;
      file_gen_deplacement.enfiler(r.droite,mypo);
      mypo.posx:=-1;
      mypo.posy:=1*ry;
      file_gen_deplacement.enfiler(r.haut_gauche,mypo);
      mypo.posx:=1;
      mypo.posy:=(-1)*ry;
      file_gen_deplacement.enfiler(r.bas_droite,mypo);
      mypo.posx:=0;
      mypo.posy:=(-1)*ry;
      file_gen_deplacement.enfiler(r.gauche,mypo);
      mypo.posx:=0;
      mypo.posy:=1*ry;
      file_gen_deplacement.enfiler(r.haut,mypo);
      mypo.posx:=-1;
      mypo.posy:=(-1)*ry;
      file_gen_deplacement.enfiler(r.bas_gauche,mypo);
      mypo.posx:=0;
      mypo.posy:=(-1)*ry;
      file_gen_deplacement.enfiler(r.bas,mypo);
      --Roi
      r.valeur:=roi;
      r.couleur:=couleur;
      r.position.posx:=abs(4+cx);
      r.position.posy:=1+a;
      file_gen_piece.enfiler(jou.listep,r);
   end chargement_joueur;


end pack_joueur;
