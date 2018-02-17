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
#include <String.hpp>
#include <Array.hpp>

using namespace godot;

class BunnymarkV1DrawTexture : public GodotScript<Node2D> {
        GODOT_CLASS(BunnymarkV1DrawTexture);
public:
        Vector2 screenSize;
        std::vector<std::tuple<Vector2, Vector2>> bunnies = {};
        Ref<Texture> TBunny = ResourceLoader::load("res://images/godot_bunny.png");
        float gravity = 500;
        Color white = Color(1.,1.,1.,1.);
        Ref<Texture> nullTexture = Ref<Texture>();
        BunnymarkV1DrawTexture() { srand (time(NULL)); }

        void _ready() {
                owner->set_process(true);
        }

        void _draw() {
                for (int i = 0; i < bunnies.size(); i++) {
                        owner->draw_texture(TBunny, std::get<0>(bunnies[i]), white, nullTexture);
                }
        }

        void _process(const float delta) {
                screenSize = owner->get_viewport_rect().size;
                for (int i = 0; i < bunnies.size(); i++) {
                        std::tuple<Vector2, Vector2> bunny = bunnies[i];

                        Vector2 position = std::get<0>(bunny);
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

                        bunnies[i] = std::make_tuple(position, newPosition);
                }

                owner->update();
        }

        void add_bunny() {
                bunnies.push_back(std::make_tuple(Vector2(screenSize.x / 2.0, screenSize.y / 2.0), Vector2(rand()%200+50, rand()%200+50)));
        }

        void remove_bunny() {
                if (bunnies.size() == 0) {
                        return;
                }

                bunnies.pop_back();
        }

        void finish() {
                Array array;
                array.push_back((uint64_t)bunnies.size());
                owner->emit_signal("benchmark_finished", array);
        }

        static void _register_methods() {
                register_method((char *)"_ready", &BunnymarkV1DrawTexture::_ready);

                register_method((char *)"_process", &BunnymarkV1DrawTexture::_process);
                register_method((char *)"_draw", &BunnymarkV1DrawTexture::_draw);
                register_method((char *)"add_bunny", &BunnymarkV1DrawTexture::add_bunny);
                register_method((char *)"remove_bunny", &BunnymarkV1DrawTexture::remove_bunny);
                register_method((char *)"finish", &BunnymarkV1DrawTexture::finish);
        }
};
