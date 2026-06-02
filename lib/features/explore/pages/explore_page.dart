import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:go_router/go_router.dart';
import 'package:karaburun/features/explore/data/models/explore_model.dart';
import 'package:karaburun/features/explore/data/repositories/explore_repository.dart';

class ExplorePage extends StatefulWidget {
  const ExplorePage({super.key});

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  final ExploreRepository _exploreRepository = ExploreRepository();
  late Future<List<ExploreModel>> _exploreFeedFuture;

  @override
  void initState() {
    super.initState();
    _exploreFeedFuture = _exploreRepository.fetchExploreFeed(shuffle: true);
  }

  Future<void> _refreshFeed() async {
    setState(() {
      _exploreFeedFuture = _exploreRepository.fetchExploreFeed(shuffle: true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black, 
      child: RefreshIndicator(
        onRefresh: _refreshFeed,
        child: FutureBuilder<List<ExploreModel>>(
          future: _exploreFeedFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              );
            }

            if (snapshot.hasError) {
              return Center(
                child: Text(
                  "Veriler yüklenirken bir hata oluştu!\n${snapshot.error}",
                  style: const TextStyle(color: Colors.white),
                  textAlign: TextAlign.center,
                ),
              );
            }

            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(
                child: Text("Buralar henüz ıssız...", style: TextStyle(color: Colors.white)),
              );
            }

            final feeds = snapshot.data!;
            
            return ListView.builder(
              itemCount: feeds.length,
              cacheExtent: 0, 
              padding: EdgeInsets.zero, 
              itemBuilder: (context, index) {
                final item = feeds[index];
                return ExploreVideoCard(
                  key: ValueKey(item.itemId),
                  item: item,
                );
              },
            );
          },
        ),
      ),
    );
  }
}

// --- 🎬 REELS TARZI FULL EKRAN GENİŞLİĞİNDE + ÇİFT TIKLAMALI VİDEO KARTI ---
class ExploreVideoCard extends StatefulWidget {
  final ExploreModel item;
  const ExploreVideoCard({super.key, required this.item});

  @override
  State<ExploreVideoCard> createState() => _ExploreVideoCardState();
}

class _ExploreVideoCardState extends State<ExploreVideoCard> {
  VideoPlayerController? _videoController;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    
    final String r2UserAgent = dotenv.env['R2_USER_AGENT'] ?? 'KaraburunGoMobile';

    _videoController = VideoPlayerController.networkUrl(
      Uri.parse(widget.item.videoUrl),
      formatHint: VideoFormat.other,
      httpHeaders: {
        'User-Agent': r2UserAgent,
        'Accept': '*/*',
      },
    )..initialize().then((_) {
        if (mounted) {
          setState(() {
            _isInitialized = true;
          });
          _videoController?.setLooping(true);
          _videoController?.pause(); 
        }
      }).catchError((error) {
        print("Video yüklenirken patladı dayı: $error");
      });
  }

  @override
  void dispose() {
    _videoController?.pause();
    _videoController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16.0), 
      color: Colors.black,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AspectRatio(
            aspectRatio: 9 / 16, 
            child: Stack(
              alignment: Alignment.center,
              children: [
                _isInitialized && _videoController != null
                    ? GestureDetector(
                        // 🛠️ Çift tıklama ile kalıcı oynat / durdur
                        onDoubleTap: () {
                          if (mounted) {
                            setState(() {
                              _videoController!.value.isPlaying
                                  ? _videoController!.pause()
                                  : _videoController!.play();
                            });
                          }
                        },
                        // 🛠️ Basılı tutma mantığı (Hold to Play)
                        onLongPressStart: (_) {
                          if (mounted && !_videoController!.value.isPlaying) {
                            setState(() {
                              _videoController!.play();
                            });
                          }
                        },
                        onLongPressEnd: (_) {
                          if (mounted && _videoController!.value.isPlaying) {
                            setState(() {
                              _videoController!.pause();
                            });
                          }
                        },
                        // 📺 VİDEO TIKLAMASI: Sadece orijinal SnackBar uyarısı verir, detaya gitmez!
                        onTap: () {
                          ScaffoldMessenger.of(context).clearSnackBars();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Oynatmak için basılı tutun veya çift dokunun! 🎯"),
                              duration: Duration(milliseconds: 1000),
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        },
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            // 🎞️ YATAY VİDEOLARI YAMULTMADAN GÖSTERME OPERASYONU
                            // FittedBox ve BoxFit.contain sayesinde video kendi oranını korur, boşluklar siyah kalır.
                            SizedBox.expand(
                              child: Center(
                                child: FittedBox(
                                  fit: BoxFit.contain,
                                  child: SizedBox(
                                    width: _videoController!.value.size.width,
                                    height: _videoController!.value.size.height,
                                    child: VideoPlayer(_videoController!),
                                  ),
                                ),
                              ),
                            ),

                            // 📝 YAZILARI VİDEONUN İÇİNE GÖMME OPERASYONU
                            Positioned(
                              bottom: 0,
                              left: 0,
                              right: 0,
                              child: Container(
                                padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0, bottom: 40.0),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.bottomCenter,
                                    end: Alignment.topCenter,
                                    colors: [
                                      Colors.black.withValues(alpha: 0.85), 
                                      Colors.black.withValues(alpha: 0.4),
                                      Colors.transparent, 
                                    ],
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    // SADECE TITLE VE EXPLANATION BÖLGESİNE ÖZEL YÖNLENDİRİCİ
                                    GestureDetector(
                                      behavior: HitTestBehavior.opaque, 
                                      onTap: () {
                                        if (widget.item.target.isNotEmpty) {
                                          final String routingPath = widget.item.target.startsWith('/') 
                                              ? widget.item.target 
                                              : '/${widget.item.target}';
                                          
                                          context.push(routingPath);
                                        }
                                      },
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          // Title (Küçük boyut: fontSize 16)
                                          Text(
                                            widget.item.title.isNotEmpty ? widget.item.title : "Keşfet İçeriği",
                                            style: const TextStyle(
                                              color: Colors.white, 
                                              fontSize: 16, 
                                              fontWeight: FontWeight.bold,
                                              shadows: [
                                                Shadow(color: Colors.black54, blurRadius: 6, offset: Offset(0, 2))
                                              ]
                                            ),
                                          ),
                                          const SizedBox(height: 6),

                                          // 📝 Explanation (Hemen Title'ın altında)
                                          if (widget.item.explanation != null && widget.item.explanation!.isNotEmpty)
                                            Text(
                                              widget.item.explanation!,
                                              maxLines: 3,
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                color: Colors.white70, 
                                                fontSize: 12,
                                                fontWeight: FontWeight.w400,
                                                shadows: [
                                                  Shadow(color: Colors.black54, blurRadius: 4, offset: Offset(0, 1))
                                                ]
                                              ),
                                            ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            // Video o an oynatılmıyorsa ortada çıkan orijinal rozet
                            if (!_videoController!.value.isPlaying)
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                                decoration: BoxDecoration(
                                  color: Colors.black.withValues(alpha: .5),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: const Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.touch_app, color: Colors.white, size: 18),
                                    SizedBox(width: 6),
                                    Text(
                                      "Basılı Tut veya Çift Dokun",
                                      style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                      )
                    : const Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}