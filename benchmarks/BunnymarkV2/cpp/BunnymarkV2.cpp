#include <stdlib.h>
#include <vector>
#include <string> 
#include <core/Godot.hpp>
#include <core/GodotGlobal.hpp>
#include <Node2D.hpp>
#include <Texture.hpp>
#include <Sprite.hpp>
#include <Label.hpp>
#include <ResourceLoader.hpp>
#include <String.hpp>
#include <Array.hpp>

using namespace godot;

class BunnymarkV2 : public GodotScript<Node2D> {
        GODOT_CLASS(BunnymarkV2);
public:
        Vector2 screenSize;
        Ref<Texture> TBunny = ResourceLoader::load("res://images/godot_bunny.png");
        float gravity = 500; 
        std::vector<Vector2> speeds;
        Label* label = new Label();
        Node2D* bunnies = new Node2D();

        BunnymarkV2() { srand (time(NULL)); }

        void _ready() {
                owner->set_process(true);
                owner->add_child(bunnies);

                label->set_position(Vector2(0, 20));
                owner->add_child(label);
        }

        void _process(const float delta) {
                screenSize = owner->get_viewport_rect().size;

                String bunnies_count =  std::to_string(bunnies->get_child_count()).c_str();
                String label_value = "Bunnies: " + bunnies_count;
                label->set_text(label_value);

                Array bunnyChildren = bunnies->get_children();
                for (int i = 0; i < bunnyChildren.size(); i++) {
                        Sprite* bunny = (Sprite*)(Object*)bunnyChildren[i];
                        Vector2 position = bunny->get_position();
                        Vector2 speed = speeds[i];

                        position.x += speed.x * delta;
                        position.y += speed.y * delta;

                        speed.y += gravity * delta;

                        if (position.x > screenSize.x)
                        {
                            speed.x *= -1;
                            position.x = screenSize.x;
                        }
                        if (position.x < 0)
                        {
                            speed.x *= -1;
                            position.x = 0;
                        }

                        if (position.y > screenSize.y)
                        {
                            position.y = screenSize.y;
                            if ((double)rand() / RAND_MAX > 0.5)
                            {
                                speed.y = (rand() % 1100 + 50);
                            }
                            else
                            {
                                speed.y *= -0.85f;
                            }
                        }
            
                        if (position.y < 0)
                        {
                            speed.y = 0;
                            position.y = 0;
                        }

                        bunny->set_position(position);
                        speeds[i] = speed;
                }
        }

        void add_bunny() {
                Sprite* bunny = new Sprite();
                bunny->set_texture(TBunny.ptr());
                bunnies->add_child(bunny);
                bunny->set_position(Vector2(screenSize.x / 2.0, screenSize.y / 2.0));
                speeds.push_back(Vector2(rand()%200+50, rand()%200+50));
        }

        void remove_bunny() {
                int child_count = bunnies->get_child_count();
                if (child_count == 0) {
                        return;
                }
                
                Sprite* bunny = (Sprite*)bunnies->get_child(child_count - 1);
                speeds.pop_back();
                bunnies->remove_child(bunny);
        }

        void finish() {
                Array array;
                array.push_back(bunnies->get_child_count());
                owner->emit_signal("benchmark_finished", array);
        }

        static void _register_methods() {
                register_method((char *)"_ready", &BunnymarkV2::_ready);
                
                register_method((char *)"_process", &BunnymarkV2::_process);
                register_method((char *)"add_bunny", &BunnymarkV2::add_bunny);
                register_method((char *)"remove_bunny", &BunnymarkV2::remove_bunny);
                register_method((char *)"finish", &BunnymarkV2::finish);
        }
};