## Renderer Sizing
- Screen Size: 1920 x 1080
- Dungeon Viewport Size: 896 x 896
  - D1 Viewport : 448 x 448
  - D2 Viewport : 224 x 224
- Distance 0 Piece Sizing
  - Side Wall: 224 x 896
  - Front Wall: 448 x 896
- Distance 1 Piece Sizing
  - Side Wall: 112 x 448
  - Front Wall: 224 x 448
- Distance 2 Piece Sizing
  - Front Wall: 112 x 224
  - Side Wall: Unique to whether it is a *Far*, *Farther* or *Farthest* wall because of perspective 

## Renderer Ordering
- D0 Base Z: 40
- D1 Base Z: 20
- D2 Base Z: 1

## UI Ordering
- Everything but the Combat Viewport: 2
- Combat Viewport: 0
  - Combat Viewport Dialog Box: 1