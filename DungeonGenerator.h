#ifndef PCG_DUNGEON_H
#define PCG_DUNGEON_H

#include <queue>
#include <map>
#include <algorithm>
#include <random>
#include <string>
#include <vector>
#include <cmath>
#include <iostream>

enum TILE_TYPE { Empty=0, Floor=1, Corridor=2, Entrance=3, Exit=4, Door=5, Treasure=6, Monster=7, Trap=8 };

/*! Struct representing a point or vector in 2d space.
 */
typedef struct _Vec2 {
    /* Data */
    int x;
    int y;

    /* Constructors and Operators */
    _Vec2() {
        x=0;
        y=0;
    }

    _Vec2(int _x, int _y) {
        x=_x;
        y=_y;
    }

    _Vec2(const _Vec2& v) {
        x=v.x;
        y=v.y;
    }

    bool operator==(const _Vec2& rhs) const {
      return (x == rhs.x && y == rhs.y);
    }

    bool operator!=(const _Vec2& rhs) const {
      return (x != rhs.x || y != rhs.y);
    }

} Vec2;

/*! Class for Axis-Aligned Bounding Box
 *  Instances of this class are used to represent
 *  a region in 2d space.
 */
class AABB {
    public:

    AABB() {
        mPosition.x = 0;
        mPosition.y = 0;
        mSize.x = 0;
        mSize.y = 0;
    }
    AABB(int x, int y, int w, int h){
            mPosition.x = x;
            mPosition.y = y;
            mSize.x = w;
            mSize.y = h;
        }
        ~AABB(){};
    private:
        Vec2 mPosition;
        Vec2 mSize;
    public:
        int getWidth() const{
            return mSize.x;
        }
        int getHeight() const{
            return mSize.y;
        }
        int getVolume() const{
            return mSize.x * mSize.y;
        }
        Vec2 getCenter() {
            return Vec2(mPosition.x + mSize.x/2, mPosition.y + mSize.y/2);
        }
        int X() const{
            return mPosition.x;
        }
        int Y() const {
            return mPosition.y;
        }

        void setPosition(int x, int y){
            mPosition.x = x;
            mPosition.y = y;
        }
        void setSize(int w, int h){
            mSize.x = w;
            mSize.y = h;
        }
        bool isInside(Vec2 &p) const{
            return ( p.x >= mPosition.x && p.x <= (mPosition.x+mSize.x) &&
                     p.y >= mPosition.y && p.y <= (mPosition.y+mSize.y) );
        }
};


#include <unordered_set>

template<typename T>
class Node {
    public:
        Node(Node<T>* parent, T data){
            mpParent = parent;
            mpLeft = nullptr;
            mpRight = nullptr;
            mData = data;
        }

        ~Node(){
            if(mpLeft != nullptr)
                delete mpLeft;
            if(mpRight != nullptr)
                delete mpRight;
        }

    private:
        T mData;
        Node* mpParent;
        Node* mpLeft;
        Node* mpRight;
    public: // Public Methods
        T GetData(void) const{
            return mData;
        }
        Node* GetParent(void) const{
            return mpParent;
        }

        void MakeLeftChild(T data) {
            mpLeft = new Node(this, data);
        }
        Node* GetLeftChild(void) const{
            return mpLeft;
        }

        void MakeRightChild(T data){
            mpRight = new Node(this, data);
        }
        Node* GetRightChild(void) const{
            return mpRight;
        }
    public: // Public inner types
        class NodeIterator {
            public:
                NodeIterator(Node* parent){
                    mpRoot = parent;
                    mpCurrent = parent;
                }
            private:
                std::unordered_set<Node*> mVisited;
                Node* mpRoot;
                Node* mpCurrent;
            public:
                bool Next(){
                    if( mpCurrent->GetLeftChild() != 0 && mVisited.find(mpCurrent->GetLeftChild()) == mVisited.end() ) {
                        //mpCurrent->SetLeftVisited();
                        mVisited.insert(mpCurrent->GetLeftChild());
                        mpCurrent = mpCurrent->GetLeftChild();
                        return true;
                    }

                    if( mpCurrent->GetRightChild() != 0 && mVisited.find(mpCurrent->GetRightChild()) == mVisited.end() ) {
                        //mpCurrent->SetRightVisited();
                        mVisited.insert( mpCurrent->GetRightChild() );
                        mpCurrent = mpCurrent->GetRightChild();
                        return true;
                    }

                    if( mpCurrent->GetParent() != 0 ) {
                        mpCurrent = mpCurrent->GetParent();
                        return true;
                    } else {
                        return false;
                    }
                }
                T GetData() const{
                    return mpCurrent->mData;
                }
                Node* GetNode() const{
                    return mpCurrent;
                }
                bool IsLeaf() const{
                    if( mpCurrent->GetLeftChild() == 0 && mpCurrent->GetRightChild() == 0 )
                        return true;
                    else
                        return false;
                }

                void Reset(){
                    mVisited.clear();
                    mpCurrent = mpRoot;
                }
        };
};



typedef AABB Room;
typedef std::vector< Vec2 > Path;
typedef std::vector<unsigned int> GridLine;
typedef std::vector< std::vector<unsigned int> > Grid;

#define RAND_GEN_PERCENTAGE (float)mUniDistr(mRandGen)
#define DEBUG 0

/*! Class representing a randomly generated dungeon
 */
class DungeonGenerator {
    public:

    DungeonGenerator(std::string seed, int width, int height) : mWidth(width), mHeight(height), mRootNode(nullptr, AABB(0,0,width,height)) {
        // init grid
        mGrid = std::vector< std::vector< unsigned int > >(mHeight, std::vector< unsigned int >(mWidth, TILE_TYPE::Empty));

        mSeedString = seed;
        mSeedSeq = std::seed_seq( mSeedString.begin(), mSeedString.end() );
        mRandGen = std::mt19937( mSeedSeq );
        mUniDistr = std::uniform_real_distribution<float>(0.0f, 1.0f);
    }

        ~DungeonGenerator(){}
        //enum TILE_TYPE { Empty=0, Floor=1, Corridor=2, Entrance=3, Exit=4, Door=5, Treasure=6, Monster=7, Trap=8 };
    private:
        int mWidth;
        int mHeight;
        int mUnitSquare;
        std::mt19937 mRandGen;
		std::uniform_real_distribution<float> mUniDistr;
        std::seed_seq mSeedSeq;
        std::string mSeedString;
        std::vector< Room > mRooms;
        std::vector< Path > mCorridors;
		std::vector< Vec2 > mTreasures;
		std::vector< Vec2 > mMonsters;
		std::vector< Vec2 > mTraps;
        Vec2 mEntrance;
        Vec2 mExit;
        Grid mGrid;
        Node<AABB> mRootNode;
    public:
        void Generate() {
            // Clean-up if already generated
            mRootNode = Node<AABB>(nullptr, AABB(0, 0, mWidth, mHeight));
            mRooms.clear();
            mCorridors.clear();
            mTreasures.clear();
            mMonsters.clear();
            mTraps.clear();
            ClearGrid();

            // Generate dungeon parts
            SplitSpace(&mRootNode);
            FindRoomsDigCorridors();
            BakeFloor();
            PlaceEntranceAndExit();
            PlaceDoors();
            PlaceTreasureAndMonsters();
            BakeDetails();

            std::cout << "Dungeon Generation complete!" << std::endl;

            #ifdef DEBUG
                for(int i = 0; i<mGrid.size(); i++) {
                    for(int j = 0; j<mGrid[i].size(); j++) {
                        std::cout << mGrid[i][j];
                    }
                    std::cout << std::endl;
                }
            #endif
        }


        Grid GetGrid(void){
            return mGrid;
        }

        // Function that returns a list of points for each neighbouring grid cell of the function's center parameter
        std::vector<Vec2> GetNeighbours(Vec2 &center) {
            std::vector<Vec2> neighbours;
            neighbours.push_back( Vec2(center.x+1, center.y) );
            neighbours.push_back( Vec2(center.x-1, center.y) );
            neighbours.push_back( Vec2(center.x, center.y+1) );
            neighbours.push_back( Vec2(center.x, center.y-1) );
            return neighbours;
        }

        // Simplistic grid-based pathfinding
        Path FindPath(Vec2 begin, Vec2 end) {

            // Create needed variables and init
            // with the starting point.
            Path result;
            result.push_back(begin);
            Vec2 current = begin;

            do {
                // Get neighbours
                Path neighbours = GetNeighbours(current);
                // Find nearest
                int nearestIndex;
                int nearestRange=1000;
                for(int i=0; i<4; ++i) {
                    if( (std::abs(neighbours[i].x - end.x) + std::abs(neighbours[i].y - end.y)) < nearestRange ) {
                        nearestRange = (std::abs(neighbours[i].x - end.x) + std::abs(neighbours[i].y - end.y));
                        nearestIndex = i;
                    }
                }
                // save up and continue...
                current = neighbours[nearestIndex];
                result.push_back(current);
            } while (current != end); //... until we reach the end point

            return result;
        }

	private:
        void ClearGrid(){
            mGrid.clear();
            mGrid = std::vector< std::vector< unsigned int > >(mHeight, std::vector< unsigned int >(mWidth, TILE_TYPE::Empty));
        }

        void SplitSpace(Node<AABB>* node){

            // Choose how and where to split
            float ratio = (float)node->GetData().getWidth() / node->GetData().getHeight();
            bool splitVertical = true;
            if(ratio < 1.0f)
                splitVertical = false;


            float split = RAND_GEN_PERCENTAGE;
            do {
                split = RAND_GEN_PERCENTAGE;
            } while (split < 0.4f || split > 0.6f);


            // Create and calculate the 2 subspaces
            // of the splitted one.
            AABB subspaceA, subspaceB;

            if( splitVertical ) {
                int splitX = node->GetData().X() + (int)(split * node->GetData().getWidth());
                subspaceA = AABB( node->GetData().X(), node->GetData().Y(),
                                  (int)(split * node->GetData().getWidth()), node->GetData().getHeight() );
                subspaceB = AABB( splitX, node->GetData().Y(),
                                  (int)((1-split) * node->GetData().getWidth()), node->GetData().getHeight() );
            } else {
                int splitY = node->GetData().Y() + (int)(split * node->GetData().getHeight());
                subspaceA = AABB( node->GetData().X(), node->GetData().Y(),
                                  node->GetData().getWidth(), (int)(split * node->GetData().getHeight()) );
                subspaceB = AABB( node->GetData().X(), splitY,
                                  node->GetData().getWidth(), (int)((1-split) * node->GetData().getHeight()) );
            }

            #ifdef DEBUG
                std::cout << "Splitting [" << node->GetData().X() << ", " << node->GetData().Y() << ", " << node->GetData().getWidth() << ", " << node->GetData().getHeight() << "] into:" << std::endl;
                std::cout << "Space A: [" << subspaceA.X() << ", " << subspaceA.Y() << ", " << subspaceA.getWidth() << ", " << subspaceA.getHeight() << "]" << std::endl;
                std::cout << "Space B: [" << subspaceB.X() << ", " << subspaceB.Y() << ", " << subspaceB.getWidth() << ", " << subspaceB.getHeight() << "]" << std::endl;
                std::cout << std::endl;
            #endif

            // Add subspaces to the current node
            node->MakeLeftChild(subspaceA);
            node->MakeRightChild(subspaceB);

            // Decide if we need to split more
            // and continue recursion.
            if( subspaceA.getWidth() > 7 && subspaceA.getHeight() > 6 )
                SplitSpace(node->GetLeftChild());
            if( subspaceB.getWidth() > 7 && subspaceB.getHeight() > 6 )
                SplitSpace(node->GetRightChild());

        }
        void FindRoomsDigCorridors(){
            Node<AABB>::NodeIterator it(&mRootNode);

            // Iterate over bsp-tree and add Rooms that
            // adhere to the minimum size required
            while( it.Next() != false ) {
                if( it.IsLeaf() == true && it.GetData().getWidth() > 3 && it.GetData().getHeight() > 3 ) {
                    mRooms.push_back( AABB(it.GetData().X()+1, it.GetData().Y()+1, it.GetData().getWidth()-2, it.GetData().getHeight()-2) );
                    #ifdef DEBUG
                        std::cout << "Added [" << it.GetData().X() << ", " << it.GetData().Y() << ", " << it.GetData().getWidth() << ", " << it.GetData().getHeight() << "]" << std::endl;
                    #endif
                }
            }

            it.Reset();

            // Re-iterate over bsp-tree and create
            // corridors using pathfind function (grid-based)
            while( it.Next() != false ) {
                if( !it.IsLeaf() ) {
                    Path corridor = FindPath( it.GetNode()->GetLeftChild()->GetData().getCenter(),
                                              it.GetNode()->GetRightChild()->GetData().getCenter() );
                    mCorridors.push_back(corridor);

                    #ifdef DEBUG
                        std::cout << "Corridor points from [" << it.GetNode()->GetLeftChild()->GetData().getCenter().x << ", " << it.GetNode()->GetLeftChild()->GetData().getCenter().y << "]" << std::endl;
                        std::cout << " to [" << it.GetNode()->GetRightChild()->GetData().getCenter().x << ", " << it.GetNode()->GetRightChild()->GetData().getCenter().y << "]" << std::endl;
                        for(Path::iterator itP = corridor.begin(); itP != corridor.end(); itP++) {
                            std::cout << itP->x << ", " << itP->y << std::endl;
                        }
                        std::cout << std::endl;
                    #endif
                }
            }

        }
        void PlaceEntranceAndExit(){

            int i, j; // i is the index of the room with the entrance
                      // j is the index of the room with the exit
            i = j = 0;

            // There are N rooms, choose if entrance will be in one
            // of the rooms of the first half (0 to N/2) or on the
            // second (N/2 to N). Exit will be on the other.
            if( RAND_GEN_PERCENTAGE > 0.5f ) {
                i = floorf( RAND_GEN_PERCENTAGE * (mRooms.size() / 2.0f) );
                j = floorf( (mRooms.size() / 2.0f) + RAND_GEN_PERCENTAGE * (mRooms.size() / 2.0f) );
            } else {
                j = floorf( RAND_GEN_PERCENTAGE * (mRooms.size() / 2.0f) );
                i = floorf( (mRooms.size() / 2.0f) + RAND_GEN_PERCENTAGE * (mRooms.size() / 2.0f) );
            }

            // Set the center of the rooms as entrance and exit
            mEntrance = mRooms[i].getCenter();
            mExit = mRooms[j].getCenter();

            #ifdef DEBUG
                std::cout << "Entrance: [" << mEntrance.x << ", " << mEntrance.y << "]" << std::endl;
                std::cout << "Exit: [" << mExit.x << ", " << mExit.y << "]" << std::endl;
            #endif

        }
        void BakeFloor(){
            std::cout << std::endl << "Baking data on mGrid..." << std::endl;

            // Fill rooms on the grid with the proper id (floor=1)
            for(std::vector< Room >::iterator it = mRooms.begin(); it != mRooms.end(); ++it) {
                for(int i = it->Y(); i < it->Y()+it->getHeight(); i++) {
                    for(int j = it->X(); j < it->X()+it->getWidth(); j++) {
                        mGrid[i][j] = TILE_TYPE::Floor;
                    }
                }
            }

            // Fill corridors on the grid with the proper id (corridor=2)
            for(std::vector< Path >::iterator it = mCorridors.begin(); it != mCorridors.end(); ++it) {
                for(Path::iterator pathIt = it->begin(); pathIt != it->end(); ++pathIt) {
                    if(mGrid[pathIt->y][pathIt->x] != 1)
                        mGrid[pathIt->y][pathIt->x] = TILE_TYPE::Corridor;
                }
            }

        }
        void PlaceDoors(){
            // Detects corridor-room crossings and
            // places doors (door=5)
            // *fix* weird door placement sometimes
            for(int i = 1; i < mGrid.size()-1; i++) {
                for(int j = 1; j < mGrid[i].size()-1; j++) {
                    if( mGrid[i][j] == 2 && (mGrid[i+1][j] == 1 || mGrid[i-1][j] == 1 || mGrid[i][j+1] == 1 || mGrid[i][j-1] == 1) &&
                        (mGrid[i+1][j] != 5 && mGrid[i-1][j] != 5 && mGrid[i][j+1] != 5 && mGrid[i][j-1] != 5) &&
                        ((mGrid[i+1][j] == 0 && mGrid[i-1][j] == 0) || (mGrid[i][j+1] == 0 && mGrid[i][j-1] == 0)) )
                            {
                                mGrid[i][j] = TILE_TYPE::Door;
                            }
                }
            }
        }
        void PlaceTreasureAndMonsters(){
            // Iterate rooms and place treasure, monsters and traps
            for(std::vector< Room >::iterator it = mRooms.begin(); it != mRooms.end(); ++it) {
                int scale = (int)((float)it->getVolume()/8.0f);
                // Monsters
                for(int i = 0; i<scale; i++)
                    mMonsters.push_back( Vec2(it->X() + (int)(it->getWidth() * RAND_GEN_PERCENTAGE), it->Y() + (int)(it->getHeight() * RAND_GEN_PERCENTAGE)) );
                // Treasures
                if( scale > 3) {
                    mTreasures.push_back( Vec2(it->X() + (int)(it->getWidth() * RAND_GEN_PERCENTAGE), it->Y() + (int)(it->getHeight() * RAND_GEN_PERCENTAGE)) );
                    mTreasures.push_back( Vec2(it->X() + (int)(it->getWidth() * RAND_GEN_PERCENTAGE), it->Y() + (int)(it->getHeight() * RAND_GEN_PERCENTAGE)) );
                } else if (scale >= 1)
                    mTreasures.push_back( Vec2(it->X() + (int)(it->getWidth() * RAND_GEN_PERCENTAGE), it->Y() + (int)(it->getHeight() * RAND_GEN_PERCENTAGE)) );
                // Traps
                if( RAND_GEN_PERCENTAGE > 0.35f )
                    mTraps.push_back( Vec2(it->X() + (int)(it->getWidth() * RAND_GEN_PERCENTAGE), it->Y() + (int)(it->getHeight() * RAND_GEN_PERCENTAGE)) );
            }
        }
        void BakeDetails(){
            // Write the details of the dungeon to its grid.
            // Details = Entrance/Exit, Monsters, Treasure and Traps

            // Entrance and exit...
            mGrid[mEntrance.y][mEntrance.x] = TILE_TYPE::Entrance;
            mGrid[mExit.y][mExit.x] = TILE_TYPE::Exit;
            // Monsters...
            for(std::vector< Vec2 >::iterator it = mMonsters.begin(); it != mMonsters.end(); ++it)
                mGrid[it->y][it->x] = TILE_TYPE::Monster;
            // Treasure...
            for(std::vector< Vec2 >::iterator it = mTreasures.begin(); it != mTreasures.end(); ++it)
                mGrid[it->y][it->x] = TILE_TYPE::Treasure;
            // Traps...
            for(std::vector< Vec2 >::iterator it = mTraps.begin(); it != mTraps.end(); ++it)
                mGrid[it->y][it->x] = TILE_TYPE::Trap;
        }


};



#endif
