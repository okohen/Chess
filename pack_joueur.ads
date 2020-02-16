with pack_piece,pack_file_gen;
use pack_piece;

package pack_joueur is

   procedure printPiece(x:t_piece);

   package file_gen_piece is new pack_file_gen(16,t_piece,printPiece);
   use file_gen_piece;

   type t_joueur is record
      name:string(1..2);
      couleur:t_couleur;
      listep:file_gen_piece.tfile;
   end record;

   procedure afficher(j: in t_joueur);
   procedure saisi(j:in out t_joueur;coul:t_couleur);
   procedure initpiece(piece: in out t_piece);
   procedure chargement_joueur(jou:in out t_joueur;couleur:in t_couleur);



end pack_joueur;
