#include <stdlib.h>
#include <vector>
#include <tuple>
#include <string>
#include <core/Godot.hpp>
#include <core/GodotGlobal.hpp>
#include <Node2D.hpp>
#include <Texture.hpp>
#include <Sprite.hpp>
#include <ResourceLoader.hpp>
#include <Array.hpp>

using namespace godot;

class BunnymarkV1Sprites : public GodotScript<Node2D> {
        GODOT_CLASS(BunnymarkV1Sprites);
public:
        Vector2 screenSize;
        std::vector<std::tuple<Sprite*, Vector2>> bunnies = {};
        Ref<Texture> TBunny = ResourceLoader::load("res://images/godot_bunny.png");
        float gravity = 500;

        BunnymarkV1Sprites() { srand (time(NULL)); }

        void _ready() {
                owner->set_process(true);
        }

        void _process(const float delta) {
                screenSize = owner->get_viewport_rect().size;
                for (int i = 0; i < bunnies.size(); i++) {
                        std::tuple<Sprite*, Vector2> bunny = bunnies[i];
                        Sprite* bunnySprite = std::get<0>(bunny);
                        Vector2 position = bunnySprite->get_position();
                        Vector2 newPosition = std::get<1>(bunny);

                        position.x += newPosition.x * delta;
                        position.y += newPosition.y * delta;

                        newPosition.y += gravity * delta;

                        if (position.x > screenSize.x)
                        {
                            newPosition.x *= -1;
                            position.x = screenSize.x;
                        }
                        if (position.x < 0)
                        {
                            newPosition.x *= -1;
                            position.x = 0;
                        }

                        if (position.y > screenSize.y)
                        {
                            position.y = screenSize.y;
                            if ((double)rand() / RAND_MAX > 0.5)
                            {
                                newPosition.y = (rand() % 1100 + 50);
                            }
                            else
                            {
                                newPosition.y *= -0.85f;
                            }
                        }

                        if (position.y < 0)
                        {
                            newPosition.y = 0;
                            position.y = 0;
                        }
                        bunnySprite->set_position(position);
                        bunnies[i] = std::make_tuple(bunnySprite, newPosition);
                }
        }

        void add_bunny() {
                Sprite* bunny = new Sprite();
                bunny->set_texture(TBunny.ptr());
                owner->add_child(bunny);
                bunny->set_position(Vector2(screenSize.x / 2.0, screenSize.y / 2.0));
                bunnies.push_back(std::make_tuple(bunny, Vector2(rand()%200+50, rand()%200+50)));
        }

        void remove_bunny() {
                if (bunnies.size() == 0) {
                        return;
                }

                owner->remove_child(std::get<0>(bunnies[bunnies.size() - 1]));
                bunnies.pop_back();
        }

        void finish() {
                Array array;
                array.push_back((uint64_t)bunnies.size());
                owner->emit_signal("benchmark_finished", array);
        }

        static void _register_methods() {
                register_method((char *)"_ready", &BunnymarkV1Sprites::_ready);

                register_method((char *)"_process", &BunnymarkV1Sprites::_process);
                register_method((char *)"add_bunny", &BunnymarkV1Sprites::add_bunny);
                register_method((char *)"remove_bunny", &BunnymarkV1Sprites::remove_bunny);
                register_method((char *)"finish", &BunnymarkV1Sprites::finish);
        }
};