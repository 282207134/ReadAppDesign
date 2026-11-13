class Book {
  const Book(this.id, this.title, this.author, this.description, this.category);
  final String id, title, author, description, category;
  String get image => 'assets/images/$id.png';
  double get price => 60;
}

const books = [
  Book(
    'cannes',
    'Sortir a Cannes',
    'Michael, Jost',
    'After Thomas, Kruger and Bellucci, discover the artists, stories and unforgettable moments of Cannes. A journey through the greatest country in the history of cinema.',
    'Art',
  ),
  Book(
    'children',
    'Empowering children and youth',
    'Justin Peter',
    'This book introduces children’s stories of courage and possibility. Meet the people making a brighter future, one community at a time.',
    'Life',
  ),
  Book(
    'gorilla',
    'Chimpanzee Revelation',
    'Gillian',
    'The renowned scientist explores the extraordinary lives of our closest relatives, and what they can teach us about ourselves.',
    'Science',
  ),
  Book(
    'all-this',
    'All this has',
    'Anna',
    'A thoughtful novel about memory, belonging and the small moments that make up a life.',
    'Literature',
  ),
  Book(
    'good-art',
    'Good Art',
    'Yvette',
    'Neil Gaiman’s invitation to make good art, follow your curiosity and find your own creative voice.',
    'Design',
  ),
  Book(
    'growth',
    'Global fund for Growth',
    'Charlene',
    'Stories of community-led change and the ideas that help young people grow.',
    'Economic',
  ),
  Book(
    'sculpture',
    'Free sculpture',
    'Marlene Anna',
    'An illustrated exploration of form, balance and the art of seeing ordinary things anew.',
    'Art',
  ),
  Book(
    'water',
    'Waterrl-G',
    'Mike Rose',
    'A lyrical journey through waterways, landscapes and the places we call home.',
    'Life',
  ),
];

const authorNames = [
  'Marlene Anna',
  'Charlene',
  'Yvette',
  'Teny',
  'Justin Peter',
  'Anna',
  'Gillian',
];
const authorImages = [
  'author',
  'charlene',
  'yvette',
  'teny',
  'justin',
  'anna',
  'gillian',
];

class Review {
  const Review(this.author, this.avatar, this.text);
  final String author, avatar, text;
}

const initialReviews = [
  Review(
    'Bronte three sisters',
    'profile',
    'One of the most powerful novels in the history of literature',
  ),
  Review(
    'Justin Peter',
    'justin',
    'One of the most powerful novels in the history of literature',
  ),
  Review(
    'Justin Peter',
    'justin',
    'Every good design needs a good designer and a good teacher to teach. Every design must start from the heart.',
  ),
  Review(
    'Marlene Anna',
    'anna',
    'This is probably the only rhythm of belonging to an author, just like the same pile of nouns in the hands of other writers.',
  ),
  Review(
    'Michael, Jost',
    'author',
    'Fantasy theme works are the main line woven in and out.',
  ),
];
